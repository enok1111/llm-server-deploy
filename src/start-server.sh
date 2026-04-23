#!/bin/bash
# =============================================
# Script optimizado para Qwen3.6-27B en RTX 3090
# =============================================

source "$(dirname "$0")/../config.sh"

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export GGML_CUDA_GRAPH_OPT=1

export LLAMA_ATTN_ROT_DISABLE=1 

SERVER_BIN="$LLAMA_DIR/build/bin/llama-server"
MODEL_PATH="$MODELS_DIR/$MODEL_FILENAME"

echo "🚀 Iniciando llama-server con modelo: $MODEL_FILENAME"

nohup "$SERVER_BIN" \
  -m "$MODEL_PATH" \
  -c "$CONTEXT_SIZE" \
  -ngl 80 \
  -np 1 \
  --flash-attn on \
  --cache-type-k q4_0 \
  --cache-type-v q4_0 \
  -b "$BATCH_SIZE" \
  -ub "$BATCH_SIZE" \
  --port "$PORT" \
  --host 0.0.0.0 \
  --api-key "$API_KEY" \
  --no-webui \
  > "$LOG_FILE" 2>&1 &
  
echo $! > "$BASE_DIR/server.pid"