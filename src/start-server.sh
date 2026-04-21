#!/bin/bash
source "$(dirname "$0")/../config.sh"

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export GGML_CUDA_GRAPH_OPT=1

SERVER_BIN="$LLAMA_DIR/build/bin/llama-server"
MODEL_PATH="$MODELS_DIR/$MODEL_FILENAME"

# NOTA TÉCNICA: 
# El modelo tiene 41 capas. 
# -ngl 30 mete ~16GB en la VRAM de la RTX 3090, dejando 8GB libres.
# Esos 8GB libres serán usados por los 192k de contexto en formato q4_0.
# Las 11 capas restantes se ejecutarán en la memoria RAM del sistema.

nohup "$SERVER_BIN" \
  -m "$MODEL_PATH" \
  -c "$CONTEXT_SIZE" \
  -ngl 30 \
  -fa 1 \
  --parallel 1 \
  -ctk q4_0 \
  -ctv q4_0 \
  -t "$THREADS" \
  -b "$BATCH_SIZE" \
  -ub "$BATCH_SIZE" \
  --api-key "$API_KEY" \
  --port "$PORT" \
  --host 0.0.0.0 \
  > "$LOG_FILE" 2>&1 &

echo $! > "$BASE_DIR/server.pid"