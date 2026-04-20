#!/bin/bash
source "$(dirname "$0")/config.sh"

echo "🛠️ [1/3] Instalando dependencias del sistema y CUDA Toolkit..."
sudo apt-get update
sudo apt-get install -y build-essential cmake git libcurl4-openssl-dev libssl-dev aria2 nvidia-cuda-toolkit

# Configurar rutas de CUDA para la compilación
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

echo "📥[2/3] Descargando y preparando llama.cpp..."
cd "$BASE_DIR"
if [ ! -d "$LLAMA_DIR" ]; then
    git clone https://github.com/ggerganov/llama.cpp
fi

cd "$LLAMA_DIR"
# Limpiar compilaciones previas si las hay
rm -rf build && mkdir build && cd build

echo "🏗️ [3/3] Compilando para NVIDIA CUDA (Multi-GPU)..."
cmake .. -DGGML_CUDA=ON
cmake --build . --config Release -j $(nproc)

echo "✅ Instalación y compilación completadas con éxito."
