#!/bin/bash
# ==========================================
# Script de Ejecución Unificado
# ==========================================

# Selección de perfil y parámetros
while [[ $# -gt 0 ]]; do
    case $1 in
        --vl) export MODEL_PROFILE="QWEN_VL_3B"; shift ;;
        --vision) export USE_VISION=true; shift ;;
        --temp) export TEMPERATURE="$2"; shift 2 ;;
        --top-p) export TOP_P="$2"; shift 2 ;;
        --min-p) export MIN_P="$2"; shift 2 ;;
        --top-k) export TOP_K="$2"; shift 2 ;;
        --repeat-penalty) export REPEAT_PENALTY="$2"; shift 2 ;;
        *) shift ;;
    esac
done

source "$(dirname "$0")/config.sh"

echo "🧹 Limpiando procesos antiguos..."
pkill -f llama-server || true
pkill -f monitor.sh || true
sleep 2

echo "🚀 Arrancando Servidor LLM ($MODEL_PROFILE)..."
chmod +x "$BASE_DIR/src/start-server.sh"
chmod +x "$BASE_DIR/src/monitor.sh"

# Iniciar servidor
bash "$BASE_DIR/src/start-server.sh"

# Iniciar monitor
nohup bash "$BASE_DIR/src/monitor.sh" > "$BASE_DIR/monitor.log" 2>&1 &

echo "========================================="
echo "✨ Servidor en línea (Puerto: $PORT)"
echo "📊 Perfil: $MODEL_PROFILE | Visión: $USE_VISION"
echo "🌡️ Temp: $TEMPERATURE | Top-P: $TOP_P | Min-P: $MIN_P"
echo "🔢 Top-K: $TOP_K | Penalty: $REPEAT_PENALTY"
echo "📝 Logs: tail -f $LOG_FILE"
echo "🛑 Detener: pkill -f llama-server && pkill -f monitor.sh"
echo "========================================="
