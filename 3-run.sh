#!/bin/bash
source "$(dirname "$0")/config.sh"

echo "🧹 Limpiando procesos antiguos..."
pkill -f llama-server || true
pkill -f monitor.sh || true
sleep 2

echo "🚀 Arrancando Servidor LLM..."
chmod +x "$BASE_DIR/src/start-server.sh"
chmod +x "$BASE_DIR/src/monitor.sh"

# Detectar flag de visión
export USE_VISION=false
if [[ "$*" == *"--vision"* ]]; then
    echo "👁️ Modo visión activado"
    export USE_VISION=true
fi

# Iniciar servidor
bash "$BASE_DIR/src/start-server.sh"

# Iniciar monitor
nohup bash "$BASE_DIR/src/monitor.sh" > "$BASE_DIR/monitor.log" 2>&1 &

echo "========================================="
echo "✨ Servidor en línea (Puerto interno: $PORT)"
echo "📊 Sigue los logs con: tail -f $LOG_FILE"
echo "🛑 Para detener: pkill -f llama-server && pkill -f monitor.sh"
echo "========================================="
