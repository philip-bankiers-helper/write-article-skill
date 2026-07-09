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
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"; do
  if [ -x "$c" ]; then CHROME="$c"; break; fi
done
[ -n "$CHROME" ] || { echo "no Chrome/Chromium/Edge found" >&2; exit 1; }

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

DIMS="$(sips -g pixelWidth -g pixelHeight "$OUT" 2>/dev/null | awk '/pixelWidth/{w=$2} /pixelHeight/{h=$2} END{printf "%sx%s", w, h}')"
echo "rendered $OUT (${DIMS} px)"
