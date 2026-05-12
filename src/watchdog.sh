#!/bin/bash
# =============================================================
# Watchdog V3.4: Non-Blocking & PID-Based
# =============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

WATCHDOG_LOG="$BASE_DIR/watchdog.log"
CHECK_INTERVAL=30
MAX_FAILS=3
FAIL_COUNT=0

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$WATCHDOG_LOG"
}

# Instalación silenciosa de herramientas si faltan
if ! command -v curl >/dev/null 2>&1 || ! command -v pgrep >/dev/null 2>&1; then
    log "⚙️ Instalando herramientas de sistema..."
    apt-get update -qq && apt-get install -y curl procps -qq >/dev/null 2>&1
fi

start_server() {
    log "🚀 Launching start-server.sh (Async)..."
    # Lanzamos en background y redirigimos para que el watchdog no espere
    bash "$BASE_DIR/src/start-server.sh" > /dev/null 2>&1 &
    sleep 10
}

stop_server() {
    log "🛑 Cleaning up old processes..."
    pkill -9 -f "llama-server -m" || true
    rm -f "$PID_FILE"
    sleep 2
}

log "🐕 Watchdog V3.4 started on port $PORT"

while true; do
    # 1. Verificar si el proceso existe (usando pgrep para mayor seguridad en Docker)
    if ! pgrep -f "llama-server -m" > /dev/null; then
        log "⚠️ Server process not found. Starting..."
        FAIL_COUNT=0
        start_server
        continue
    fi

    # 2. Check HTTP Health
    # Usamos localhost y omitimos proxy para evitar problemas de red interna
    HTTP_STATUS=$(curl -s --noproxy "*" -m 10 -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/health" || echo "000")

    case "$HTTP_STATUS" in
        200|401|403)
            if [ "$FAIL_COUNT" -gt 0 ]; then log "✅ Server recovered (HTTP $HTTP_STATUS)."; fi
            FAIL_COUNT=0
            ;;
        503)
            log "⏳ Model loading (503)..."
            FAIL_COUNT=0
            ;;
        000)
            # El puerto aún no responde, pero el proceso existe. Esperamos.
            log "🔌 Server process exists but port $PORT is not yet open."
            FAIL_COUNT=0
            ;;
        *)
            FAIL_COUNT=$((FAIL_COUNT + 1))
            log "⚠️ Health check failed ($HTTP_STATUS). Attempt $FAIL_COUNT/$MAX_FAILS"
            ;;
    esac

    # 3. Reinicio por fallos acumulados
    if [ "$FAIL_COUNT" -ge "$MAX_FAILS" ]; then
        log "🚨 Server unresponsive. Performing hard restart..."
        stop_server
        start_server
        FAIL_COUNT=0
    fi

    sleep "$CHECK_INTERVAL"
done
