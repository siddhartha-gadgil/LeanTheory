#!/usr/bin/env bash
# Make sure the LeanTheory task server (`theory_server`) is running on 127.0.0.1:PORT.
#
# usage: scripts/theory_server/ensure_server.sh [PORT]      (default: $THEORY_SERVER_PORT or 8080)
#
# If the server already answers, report it and exit. Otherwise build it, start it in the background
# and wait until it answers (importing Mathlib takes a while), then exit. The log and the process id
# are kept in .lake/theory_server/. Exit status 0 means the server is ready. Linux, macOS or WSL.
# Stop the server with scripts/theory_server/stop_server.sh [PORT].
set -euo pipefail

PORT="${1:-${THEORY_SERVER_PORT:-8080}}"
TIMEOUT="${THEORY_SERVER_TIMEOUT:-600}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STATE="$ROOT/.lake/theory_server"
URL="http://127.0.0.1:$PORT/"
LOG="$STATE/server-$PORT.log"
PIDFILE="$STATE/server-$PORT.pid"

alive() { [ "$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "$URL" 2>/dev/null)" = 200 ]; }

if alive; then
  echo "theory_server ready at $URL"
  exit 0
fi

command -v lake >/dev/null 2>&1 || { [ -f "$HOME/.elan/env" ] && . "$HOME/.elan/env"; }
command -v lake >/dev/null 2>&1 || { echo "lake not found: set up Lean first (scripts/setup.sh)" >&2; exit 1; }

mkdir -p "$STATE"
cd "$ROOT"
echo "building theory_server ..." >&2
lake build theory_server >&2
# Run the binary itself (not through `lake exe`), so that the recorded pid is the server's.
LEAN_PATH="$(lake env printenv LEAN_PATH)" nohup "$ROOT/.lake/build/bin/theory_server" "$PORT" \
  > "$LOG" 2>&1 &
echo $! > "$PIDFILE"
echo "starting theory_server on port $PORT (pid $(cat "$PIDFILE"), log $LOG) ..." >&2

start=$(date +%s)
until alive; do
  if ! kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    echo "theory_server exited before becoming ready; end of $LOG:" >&2
    tail -20 "$LOG" >&2
    exit 1
  fi
  if [ $(( $(date +%s) - start )) -ge "$TIMEOUT" ]; then
    echo "theory_server not ready after ${TIMEOUT}s; see $LOG" >&2
    exit 1
  fi
  sleep 2
done
echo "theory_server ready at $URL (pid $(cat "$PIDFILE"), log $LOG)"
