#!/bin/bash
source "$(dirname "$0")/../config.sh"

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export GGML_CUDA_GRAPH_OPT=1

SERVER_BIN="$LLAMA_DIR/build/bin/llama-server"
MODEL_PATH="$MODELS_DIR/$MODEL_FILENAME"

nohup "$SERVER_BIN" \
  -m "$MODEL_PATH" \
  -c "$CONTEXT_SIZE" \
  -ngl 80 \
  -fa 1 \
  --parallel 1 \
  -ctk q4_0 \
  -ctv q4_0 \
  -t "$THREADS" \
  -b "$BATCH_SIZE" \
  -ub "$BATCH_SIZE" \
  --port "$PORT" \
  --host 0.0.0.0 \
  --api-key "$API_KEY" \
  > "$LOG_FILE" 2>&1 &

echo $! > "$BASE_DIR/server.pid"