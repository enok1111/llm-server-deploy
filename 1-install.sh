#!/bin/bash
set -eo pipefail 

source "$(dirname "$0")/config.sh"

echo "📥 Preparando entorno estable..."
apt-get update
apt-get --fix-broken install -y

apt-get install -y clang build-essential cmake git libcurl4-openssl-dev libssl-dev aria2 nvidia-cuda-toolkit procps curl jq

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

echo "🔄 Clonando repositorio llama.cpp..."
if [ -d "$LLAMA_DIR" ]; then rm -rf "$LLAMA_DIR"; fi
git clone --depth 1 https://github.com/ggerganov/llama.cpp "$LLAMA_DIR"

cd "$LLAMA_DIR" && mkdir -p build && cd build

echo "🏗️ Configurando CMake en MODO SUPERVIVENCIA (-O0)..."
# -O0 desactiva toda optimización para evitar estresar la RAM/CPU defectuosa del host
cmake .. -DGGML_CUDA=ON \
    -DCMAKE_CUDA_ARCHITECTURES="86" \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_C_FLAGS="-O0" \
    -DCMAKE_CXX_FLAGS="-O0" \
    -DGGML_NATIVE=OFF \
    -DCMAKE_CUDA_FLAGS="-allow-unsupported-compiler"

echo "🔨 Compilando con 1 SOLO HILO..."
cmake --build . --config Release -j 1 --target llama-cli llama-mtmd-cli llama-server llama-gguf-split

echo "✅ Compilación completada con éxito."