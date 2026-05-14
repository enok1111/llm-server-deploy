#!/bin/bash
source "$(dirname "$0")/../config.sh"

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export GGML_CUDA_GRAPH_OPT=1
export LLAMA_ATTN_ROT_DISABLE=1 

echo "🚀 Iniciando servidor: $SERVER_BIN"

VISION_ARGS=""
if [ "$USE_VISION" = true ] && [ -f "$MODELS_DIR/$VISION_MODEL_FILENAME" ]; then
    VISION_ARGS="--mmproj $MODELS_DIR/$VISION_MODEL_FILENAME"
fi

nohup "$SERVER_BIN" \
  -m "$MODELS_DIR/$MODEL_FILENAME" \
  $VISION_ARGS \
  -c "$CXT_SIZE" \
  -ngl 60 \
  -np 1 \
  --flash-attn on \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  -b "$BATCH_SIZE" \
  -ub "$BATCH_SIZE" \
  --port "$PORT" \
  --host 0.0.0.0 \
  --api-key "$API_KEY" \
  --temp "$TEMPERATURE" \
  --top-p "$TOP_P" \
  --min-p "$MIN_P" \
  --repeat-penalty "$REPEAT_PENALTY" \
  --presence-penalty 0.4 \
  --no-webui \
  --jinja \
  --ctx-checkpoints "$CTX_CHECKPOINTS" \
  > "$LOG_FILE" 2>&1 &
  
echo $! > "$PID_FILE"
echo "✅ PID guardado en $PID_FILE"
