#!/bin/bash
# =============================================================
# Watchdog V3.1: Simple & Robust Health Check (Fixed Startup)
# =============================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

WATCHDOG_LOG="$BASE_DIR/watchdog.log"
CHECK_INTERVAL=30
MAX_FAILS=3
FAIL_COUNT=0

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$WATCHDOG_LOG"
}

start_server() {
    log "🚀 Starting llama-server via start-server.sh..."
    bash "$BASE_DIR/src/start-server.sh"
    sleep 5
}

stop_server() {
    log "🛑 Hard killing llama-server..."
    pkill -9 -f "llama-server -m" || true
    sleep 5
}

log "🐕 Watchdog V3.1 started monitoring port $PORT"

while true; do
    # 1. Check if the process is alive
    if ! pgrep -f "llama-server -m" > /dev/null; then
        log "⚠️ Process not found. Triggering start..."
        FAIL_COUNT=0
        start_server
        sleep 10
        continue
    fi

    # 2. Check HTTP Health
    # We use -w "%{http_code}" to get the status. 000 means connection refused (port not open).
    HTTP_STATUS=$(curl -s -m 15 -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/health" || echo "000")

    case "$HTTP_STATUS" in
        200)
            # Ready and serving
            if [ "$FAIL_COUNT" -gt 0 ]; then
                log "✅ Server is back online (HTTP 200)."
            fi
            FAIL_COUNT=0
            ;;
        503)
            # Still loading model - This is normal for large models
            log "⏳ Server is loading model (HTTP 503)..."
            FAIL_COUNT=0
            ;;
        000)
            # Port not open yet - Server is still initializing binary
            log "🔌 Port $PORT not open yet. Waiting for llama-server to initialize..."
            FAIL_COUNT=0 
            ;;
        *)
            # Real errors (500, 404, etc.)
            FAIL_COUNT=$((FAIL_COUNT + 1))
            log "⚠️ Health check failed (HTTP $HTTP_STATUS). Attempt $FAIL_COUNT/$MAX_FAILS"
            ;;
    esac

    # 3. Handle persistent failure
    if [ "$FAIL_COUNT" -ge "$MAX_FAILS" ]; then
        log "🚨 Server unresponsive for $MAX_FAILS checks. Restarting..."
        stop_server
        start_server
        FAIL_COUNT=0
        sleep 30
    fi

    sleep "$CHECK_INTERVAL"
done
