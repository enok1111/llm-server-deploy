#!/bin/bash
source "$(dirname "$0")/../config.sh"

CHECK_INTERVAL=60
LAST_ACTIVE_TIME=$(date +%s)

echo "🔄 Monitor activado. Timeout: $IDLE_TIMEOUT segundos."

while true; do
    sleep "$CHECK_INTERVAL"
    CURRENT_TIME=$(date +%s)
    
    # Busca actividad en las últimas 30 líneas
    if tail -n 30 "$LOG_FILE" 2>/dev/null | grep -Ei "slot|request|HTTP" > /dev/null; then
        LAST_ACTIVE_TIME=$CURRENT_TIME
    fi
    
    DIFF=$((CURRENT_TIME - LAST_ACTIVE_TIME))
    
    if [ "$DIFF" -gt "$IDLE_TIMEOUT" ]; then
        echo "$(date) → Inactividad de $(($IDLE_TIMEOUT/60)) min. Apagando..." >> "$LOG_FILE"
        pkill -f llama-server
        exit 0
    fi
done
