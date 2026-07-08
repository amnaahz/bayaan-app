#!/usr/bin/env bash
# Build (if needed) and serve the Bayaan web app for QA.
#
# Usage:
#   bash qa/serve.sh            # serve on :8080 (builds if build/web missing)
#   PORT=9000 bash qa/serve.sh  # custom port
#   REBUILD=1 bash qa/serve.sh  # force a fresh release build
set -euo pipefail

# Resolve repo root as the parent of this script's directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

PORT="${PORT:-8080}"

if [[ "${REBUILD:-0}" == "1" || ! -f build/web/index.html ]]; then
  echo "==> Building Flutter web (release)…"
  flutter build web --release
fi

echo "==> Serving build/web at http://localhost:${PORT}"
exec python3 -m http.server "${PORT}" --directory build/web
