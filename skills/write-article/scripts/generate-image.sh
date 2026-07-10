#!/usr/bin/env bash
# Generate or edit one image with gpt-image-2 through codex exec (thin render lane).
#
# Fresh render:  generate-image.sh <prompt-file.md> <output.png> <WxH>
#   Sends the prompt file's "## Final Generation Prompt" section.
# Retry edit:    generate-image.sh <prompt-file.md> <output.png> <WxH> <previous.png>
#   Attaches the previous frame (codex -i) and sends the prompt file's
#   "## Retry Delta" section (Change:/Preserve: spec) so the good
#   composition genuinely survives — an edit, not a re-roll.
#
# The PNG bytes are extracted from the codex session rollout log — the
# image_gen tool's own recorded output — never from files the agent placed,
# so a lazy or misbehaving executor cannot substitute a stale or edited
# image. The requested size sets the aspect ratio; the tool treats exact
# pixel dimensions as advisory.
set -euo pipefail

if [ $# -lt 3 ] || [ $# -gt 4 ]; then
  echo "usage: generate-image.sh <prompt-file.md> <output.png> <WxH> [previous.png]" >&2
  exit 2
fi

PROMPT_FILE="$1"
OUT="$2"
SIZE="$3"
PREV="${4:-}"

[ -f "$PROMPT_FILE" ] || { echo "prompt file not found: $PROMPT_FILE" >&2; exit 1; }
command -v codex >/dev/null 2>&1 || {
  echo "codex CLI not found — keep the prompt file and mark this asset pending" >&2
  exit 1
}

mkdir -p "$(dirname "$OUT")"
OUT_ABS="$(cd "$(dirname "$OUT")" && pwd)/$(basename "$OUT")"
OUT_DIR="$(dirname "$OUT_ABS")"

extract_section() {
  awk -v title="$1" '
    $0 == "## " title {flag=1; next}
    /^## /{flag=0}
    flag' "$PROMPT_FILE"
}

EXTRA_ARGS=()
if [ -n "$PREV" ]; then
  [ -f "$PREV" ] || { echo "previous image not found: $PREV" >&2; exit 1; }
  PREV_ABS="$(cd "$(dirname "$PREV")" && pwd)/$(basename "$PREV")"
  EXTRA_ARGS=(-i "$PREV_ABS")
  BODY="$(extract_section "Retry Delta")"
  [ -n "${BODY// /}" ] || {
    echo "no '## Retry Delta' section found in $PROMPT_FILE (required for edit mode)" >&2
    exit 1
  }
  TASK="The attached image is the previous frame of this asset. Call your built-in image_gen tool exactly once, now, to EDIT the attached image at size ${SIZE}, quality high, applying the RETRY DELTA below verbatim: change only what it names under Change:, and keep everything named under Preserve: identical to the attached frame. Do not rewrite, improve, or extend the delta."
  LABEL="RETRY DELTA"
else
  BODY="$(extract_section "Final Generation Prompt")"
  [ -n "${BODY// /}" ] || {
    echo "no '## Final Generation Prompt' section found in $PROMPT_FILE" >&2
    exit 1
  }
  TASK="Call your built-in image_gen tool exactly once, now, to generate one image at size ${SIZE}, quality high, from the PROMPT below, passed through verbatim: do not rewrite, improve, or extend it."
  LABEL="PROMPT"
fi

CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
LOG="$(mktemp)"
trap 'rm -f "$LOG"' EXIT

# The prompt travels via stdin ('-' positional): codex's -i/--image option is
# multi-value and would otherwise swallow a trailing prompt argument.
printf '%s' "$TASK Do not run any shell command. Do not copy, create, or modify any file. When the tool returns an image, reply with exactly: GENERATED. Only if the tool call errors or the tool is absent from your tool list, print IMAGE_TOOL_UNAVAILABLE followed by the error.

${LABEL}:
${BODY}" | codex exec \
  -C "$OUT_DIR" \
  --sandbox workspace-write \
  --skip-git-repo-check \
  --color never \
  --enable image_generation \
  --add-dir "$CODEX_HOME_DIR/generated_images" \
  -c model_reasoning_effort=medium \
  "${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"}" \
  - 2>&1 | tee "$LOG"

SID="$(sed -n 's/^session id: \([0-9a-f-]*\)$/\1/p' "$LOG" | head -1)"
[ -n "$SID" ] || { echo "generation failed: could not determine codex session id" >&2; exit 1; }

ROLLOUT="$(ls "$CODEX_HOME_DIR"/sessions/*/*/*/rollout-*"$SID".jsonl 2>/dev/null | head -1)"
[ -n "$ROLLOUT" ] || { echo "generation failed: no rollout log for session $SID" >&2; exit 1; }

python3 - "$ROLLOUT" "$OUT_ABS" <<'PY'
import base64, json, sys
rollout, out = sys.argv[1], sys.argv[2]
result = None
for line in open(rollout):
    try:
        d = json.loads(line)
    except json.JSONDecodeError:
        continue
    p = d.get('payload', d)
    if p.get('type') in ('image_generation_call', 'image_generation_end') and p.get('result'):
        result = p['result']
if not result:
    sys.exit('generation failed: no image_generation result in the session log — the executor never called image_gen')
data = base64.b64decode(result)
if not data.startswith(b'\x89PNG'):
    sys.exit('generation failed: decoded tool output is not a PNG')
with open(out, 'wb') as f:
    f.write(data)
print(f'extracted {len(data)} bytes from image_gen tool output')
PY

# Portable PNG dimensions: macOS sips, else python3 (reads the IHDR chunk), else "?".
png_dims() {
  if command -v sips >/dev/null 2>&1; then
    sips -g pixelWidth -g pixelHeight "$1" 2>/dev/null \
      | awk '/pixelWidth/{w=$2} /pixelHeight/{h=$2} END{if(w&&h)printf "%sx%s",w,h; else printf "?"}'
  else
    python3 - "$1" <<'PY'
import struct, sys
d = open(sys.argv[1], "rb").read(24)
sys.stdout.write("%dx%d" % struct.unpack(">II", d[16:24]) if d[:8] == b"\x89PNG\r\n\x1a\n" else "?")
PY
  fi
}
echo "generated $OUT_ABS ($(png_dims "$OUT_ABS") px)"
