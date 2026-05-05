#!/bin/bash
# =============================================
# Script optimizado para Qwen 2.7B / 27B
# =============================================

source "$(dirname "$0")/../config.sh"

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export GGML_CUDA_GRAPH_OPT=1

# Deshabilitar rotación de tensores si no es necesaria
export LLAMA_ATTN_ROT_DISABLE=1 

echo "🚀 Iniciando servidor con: $SERVER_BIN"
echo "📦 Modelo: $MODEL_FILENAME"

VISION_ARGS=""
if [ "$USE_VISION" = true ]; then
    if [ -f "$MODELS_DIR/$VISION_MODEL_FILENAME" ]; then
        echo "👁️ Cargando proyector de visión: $VISION_MODEL_FILENAME"
        VISION_ARGS="--mmproj $MODELS_DIR/$VISION_MODEL_FILENAME"
    else
        echo "⚠️ Error: No se encuentra el archivo de visión $VISION_MODEL_FILENAME"
        echo "Ejecuta ./2-download.sh --vision para descargarlo."
        exit 1
    fi
fi

nohup "$SERVER_BIN" \
  -m "$MODELS_DIR/$MODEL_FILENAME" \
  $VISION_ARGS \
  -c "$CXT_SIZE" \
  -ngl 99 \
  -np 1 \
  --flash-attn on \
  --cache-type-k q4_0 \
  --cache-type-v q4_0 \
  -b "$BATCH_SIZE" \
  -ub "$BATCH_SIZE" \
  --port "$PORT" \
  --host 0.0.0.0 \
  --api-key "$API_KEY" \
  --temp "$TEMPERATURE" \
  --top-p "$TOP_P" \
  --min-p "$MIN_P" \
  --top-k "$TOP_K" \
  --repeat-penalty "$REPEAT_PENALTY" \
  --no-webui \
  --jinja \
  --ctx-checkpoints "$CTX_CHECKPOINTS" \
  > "$LOG_FILE" 2>&1 &
  
echo $! > "$PID_FILE"
echo "✅ PID guardado en $PID_FILE"
