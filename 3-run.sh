#!/bin/bash
# =============================================================
# Unified Startup Script (Server-Only)
# =============================================================

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --profile) export SAMPLING_PROFILE="$2"; shift ;;
        --thinking) export ENABLE_THINKING=true ;;
        --no-thinking) export ENABLE_THINKING=false ;;
        --vision|--vl) export USE_VISION=true ;;
        --port) export PORT="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

source "$(dirname "$0")/config.sh"

echo "🧹 Cleaning up old processes..."
pkill -9 -f "llama-server -m" || true
sleep 2

echo "🚀 Launching llama-server..."

# Ensure scripts are executable
chmod +x "$BASE_DIR/src/start-server.sh"

# Start the server
bash "$BASE_DIR/src/start-server.sh"

echo "============================================================="
echo "✨ Server is now running."
echo "📊 Health Check: http://127.0.0.1:$PORT/health"
echo "📝 Server Log:   tail -f server.log"
echo "🛑 To stop:      pkill -9 -f 'llama-server'"
echo "============================================================="
