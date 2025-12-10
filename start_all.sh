#!/bin/bash
# start_all.sh
# Launches Kokoro and ComfyUI each in their own Terminal window (macOS)

set -e

# --- Paths (relative setup) ---
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
KOKORO_DIR="$BASE_DIR/kokoro"
COMFYUI_DIR="$BASE_DIR/ComfyUI"
LOG_DIR="$BASE_DIR/logs"

mkdir -p "$LOG_DIR"

# --- Kokoro Terminal ---
if [ -f "$KOKORO_DIR/start_kokoro.sh" ]; then
  echo "🔹 Opening new Terminal for Kokoro..."
  osascript <<EOF
tell application "Terminal"
    do script "cd '$KOKORO_DIR' && ./start_kokoro.sh; exec bash"
    activate
end tell
EOF
else
  echo "⚠️  Missing: $KOKORO_DIR/start_kokoro.sh"
fi

# --- ComfyUI Terminal ---
if [ -f "$COMFYUI_DIR/start_comfyui.sh" ]; then
  echo "🔹 Opening new Terminal for ComfyUI..."
  osascript <<EOF
tell application "Terminal"
    do script "cd '$COMFYUI_DIR' && ./start_comfyui.sh; exec bash"
    activate
end tell
EOF
else
  echo "⚠️  Missing: $COMFYUI_DIR/start_comfyui.sh"
fi

echo "✅ Terminals launched — both Kokoro and ComfyUI should be starting."
