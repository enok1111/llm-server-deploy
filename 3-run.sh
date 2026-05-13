#!/bin/bash
# =============================================================
# Unified Startup Script (Watchdog-Centric)
# =============================================================

source "$(dirname "$0")/config.sh"

echo "🧹 Cleaning up old processes..."
pkill -9 -f "llama-server -m" || true
pkill -9 -f "watchdog.sh" || true
sleep 2

echo "🚀 Launching Watchdog V3..."
echo "The watchdog will automatically start and monitor the llama-server."

# Ensure scripts are executable
chmod +x "$BASE_DIR/src/start-server.sh"
chmod +x "$BASE_DIR/src/watchdog.sh"

# Start the watchdog in the background
nohup bash "$BASE_DIR/src/watchdog.sh" > /dev/null 2>&1 &

echo "============================================================="
echo "✨ Watchdog is now running in the background."
echo "📊 Monitoring: http://127.0.0.1:$PORT/health"
echo "📝 Watchdog Log: tail -f watchdog.log"
echo "📝 Server Log:   tail -f server.log"
echo "🛑 To stop everything: pkill -9 -f 'llama-server|watchdog.sh'"
echo "============================================================="
