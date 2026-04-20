#!/bin/bash
# Leemos la configuración desde la carpeta padre
source "$(dirname "$0")/../config.sh"

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export GGML_CUDA_GRAPH_OPT=1

SERVER_BIN="$LLAMA_DIR/build/bin/llama-server"
MODEL_PATH="$MODELS_DIR/$MODEL_FILENAME"

nohup "$SERVER_BIN" \
  -m "$MODEL_PATH" \
  -c 262144 \
  -ngl 99 \
  -fa 1 \
  --parallel 1 \
  -ctk q4_0 \
  -ctv q4_0 \
  -t 16 \
  -b 2048 \
  -ub 2048 \
  --port 8080 \
  --host 0.0.0.0 \
  > server.log 2>&1 &

echo $! > "$BASE_DIR/server.pid"
