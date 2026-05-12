#!/bin/bash
# =============================================================
# Watchdog V4: Keep It Simple & Robust
# =============================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

WATCHDOG_LOG="$BASE_DIR/watchdog.log"
CHECK_INTERVAL=30 # Segundos entre cada chequeo
STARTUP_WAIT=90   # Segundos de gracia para que el modelo cargue tras un reinicio

log() {
    # Usamos tee para que el log se vea en la consola si se ejecuta manualmente
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$WATCHDOG_LOG"
}

# Asegurar que curl esté instalado (clave para el funcionamiento)
if ! command -v curl > /dev/null; then
    log "⚙️ 'curl' no encontrado. Instalando..."
    apt-get update -qq && apt-get install -y curl -qq
fi

log "🐕 Watchdog V4.0 iniciado. Monitorizando http://127.0.0.1:$PORT/health"

# Bucle de monitorización infinito
while true; do
    # Usamos -sf para que curl falle silenciosamente (no muestre output) y devuelva
    # un código de error si el HTTP status no es 2xx (OK).
    # --noproxy '*' es vital en Clore.ai para ignorar proxies.
    if curl -sf --noproxy "*" "http://127.0.0.1:$PORT/health" > /dev/null; then
        # El servidor está sano. No hacemos nada.
        :
    else
        # Si curl falla, es que el servidor no responde correctamente.
        log "⚠️ Health check fallido. El servidor está caído o no responde."

        log "🛑 Matando cualquier proceso residual del servidor..."
        pkill -9 -f "llama-server -m" || true
        sleep 5 # Pausa para que el sistema operativo libere el puerto de red.

        log "🚀 Lanzando el servidor de nuevo..."
        # Lanzamos el script de arranque en un subshell en segundo plano para asegurar
        # que el watchdog NUNCA se quede colgado esperando.
        (bash "$BASE_DIR/src/start-server.sh") &

        log "⏳ Esperando ${STARTUP_WAIT}s a que el modelo cargue antes del próximo chequeo..."
        sleep "$STARTUP_WAIT"
    fi

    # Esperamos al siguiente chequeo
    sleep "$CHECK_INTERVAL"
done
