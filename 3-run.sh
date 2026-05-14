#!/bin/bash
# =============================================================
# Unified Startup Script (Server-Only)
# =============================================================

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
