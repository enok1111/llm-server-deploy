#!/bin/bash
source "$(dirname "$0")/config.sh"

echo "📥 Forzando descarga y compilación fresca de llama.cpp..."
apt-get update
apt-get install -y build-essential cmake git libcurl4-openssl-dev libssl-dev aria2 nvidia-cuda-toolkit procps curl jq

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

if [ -d "$LLAMA_DIR" ]; then rm -rf "$LLAMA_DIR"; fi
git clone https://github.com/ggerganov/llama.cpp "$LLAMA_DIR"
cd "$LLAMA_DIR" && mkdir build && cd build

echo "🏗️ Compilando para NVIDIA CUDA (versión más reciente)..."
cmake .. -DGGML_CUDA=ON
cmake --build . --config Release -j $(nproc)

echo "✅ Compilación de llama.cpp completada."