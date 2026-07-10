#!/usr/bin/env bash
# Render a fixed-size article diagram HTML to a 2x PNG via headless Chrome.
# Usage: render-html.sh <input.html> <output.png> <width> <height>
#
# Chrome's --headless=new --screenshot writes the PNG within seconds but (as of
# Chrome 149 on macOS) may never exit, so the file is the success signal:
# launch Chrome in the background, wait for a stable non-empty output, kill it.
set -euo pipefail

if [ $# -ne 4 ]; then
  echo "usage: render-html.sh <input.html> <output.png> <width> <height>" >&2
  exit 2
fi

IN="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
OUT="$2"
W="$3"
H="$4"

[ -f "$IN" ] || { echo "input not found: $IN" >&2; exit 1; }

CHROME=""
for c in \
  "${CHROME_BIN:-}" \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
  google-chrome google-chrome-stable chromium chromium-browser microsoft-edge; do
  [ -n "$c" ] || continue
  if [ -x "$c" ]; then CHROME="$c"; break; fi
  if command -v "$c" >/dev/null 2>&1; then CHROME="$(command -v "$c")"; break; fi
done
[ -n "$CHROME" ] || { echo "no Chrome/Chromium/Edge found (set CHROME_BIN to override)" >&2; exit 1; }

PROFILE="$(mktemp -d)"
CHROME_PID=""
cleanup() {
  if [ -n "$CHROME_PID" ]; then
    kill "$CHROME_PID" 2>/dev/null || true
    wait "$CHROME_PID" 2>/dev/null || true
  fi
  rm -rf "$PROFILE"
}
trap cleanup EXIT INT TERM

rm -f "$OUT"

"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
  --force-device-scale-factor=2 \
  --window-size="${W},${H}" \
  --user-data-dir="$PROFILE" \
  --screenshot="$OUT" \
  "file://$IN" >/dev/null 2>&1 &
CHROME_PID=$!

DEADLINE=$((SECONDS + 30))
PREV_SIZE=-1
while [ "$SECONDS" -lt "$DEADLINE" ]; do
  if [ -s "$OUT" ]; then
    CUR_SIZE="$(wc -c < "$OUT" | tr -d ' ')"
    if [ "$CUR_SIZE" = "$PREV_SIZE" ]; then
      break
    fi
    PREV_SIZE="$CUR_SIZE"
  fi
  kill -0 "$CHROME_PID" 2>/dev/null || break
  sleep 0.4
done

kill "$CHROME_PID" 2>/dev/null || true
wait "$CHROME_PID" 2>/dev/null || true
CHROME_PID=""

[ -s "$OUT" ] || { echo "render failed: $OUT missing or empty after 30s" >&2; exit 1; }

# Portable PNG dimensions: macOS sips, else python3 (reads the IHDR chunk), else "?".
png_dims() {
  if command -v sips >/dev/null 2>&1; then
    sips -g pixelWidth -g pixelHeight "$1" 2>/dev/null \
      | awk '/pixelWidth/{w=$2} /pixelHeight/{h=$2} END{if(w&&h)printf "%sx%s",w,h; else printf "?"}'
  elif command -v python3 >/dev/null 2>&1; then
    python3 - "$1" <<'PY'
import struct, sys
d = open(sys.argv[1], "rb").read(24)
sys.stdout.write("%dx%d" % struct.unpack(">II", d[16:24]) if d[:8] == b"\x89PNG\r\n\x1a\n" else "?")
PY
  else
    printf "?"
  fi
}
echo "rendered $OUT ($(png_dims "$OUT") px)"
