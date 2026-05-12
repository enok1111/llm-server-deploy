#!/bin/bash
# =============================================================
# Watchdog V3.2: Robust Health Check (Curl & Proxy Fixes)
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

# Auto-instalar curl si el contenedor no lo tiene (típico en Clore.ai)
if ! command -v curl >/dev/null 2>&1; then
    log "⚙️ 'curl' no encontrado en el sistema. Instalando..."
    apt-get update -qq && apt-get install -y curl -qq >/dev/null 2>&1
fi

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

log "🐕 Watchdog V3.2 started monitoring port $PORT"

while true; do
    # 1. Comprobar si el proceso base sigue vivo
    if ! pgrep -f "llama-server -m" > /dev/null; then
        log "⚠️ Process not found. Triggering start..."
        FAIL_COUNT=0
        start_server
        sleep 10
        continue
    fi

    # 2. Check HTTP Health
    # Usamos --noproxy "*" para evitar que Clore.ai interfiera con localhost
    HTTP_STATUS=$(curl --noproxy "*" -s -m 15 -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/health" || echo "000")

    case "$HTTP_STATUS" in
        200|401|403)
            # Listo y sirviendo (Incluimos 401 por si alguna actu de llama.cpp pide API key en /health)
            if [ "$FAIL_COUNT" -gt 0 ]; then
                log "✅ Server is back online (HTTP $HTTP_STATUS)."
            fi
            FAIL_COUNT=0
            ;;
        503)
            # Modelo cargando en la VRAM
            log "⏳ Server is loading model (HTTP 503)..."
            FAIL_COUNT=0
            ;;
        000)
            # Puerto cerrado o curl falló
            log "🔌 Port $PORT not reachable yet. Waiting for llama-server..."
            FAIL_COUNT=0 
            ;;
        *)
            # Errores reales que requieren reinicio
            FAIL_COUNT=$((FAIL_COUNT + 1))
            log "⚠️ Health check failed (HTTP $HTTP_STATUS). Attempt $FAIL_COUNT/$MAX_FAILS"
            ;;
    esac

    # 3. Reiniciar si falla de manera persistente
    if [ "$FAIL_COUNT" -ge "$MAX_FAILS" ]; then
        log "🚨 Server unresponsive for $MAX_FAILS checks. Restarting..."
        stop_server
        start_server
        FAIL_COUNT=0
        sleep 30
    fi

    sleep "$CHECK_INTERVAL"
done
