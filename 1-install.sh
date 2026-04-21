#!/bin/bash
source "$(dirname "$0")/config.sh"

echo "🛠️ [1/3] Instalando dependencias del sistema y CUDA Toolkit..."
apt-get update
apt-get install -y build-essential cmake git libcurl4-openssl-dev libssl-dev aria2 nvidia-cuda-toolkit

# Configurar rutas de CUDA para la compilación
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

echo "📥[2/3] Descargando y preparando el fork parcheado de llama.cpp..."
cd "$BASE_DIR"

# IMPORTANTE: Eliminamos el directorio anterior si existe 
# para asegurar que descargamos el fork correcto y no usamos caché.
if [ -d "$LLAMA_DIR" ]; then
    echo "⚠️ Directorio antiguo detectado. Eliminando para clonar la versión parcheada..."
    rm -rf "$LLAMA_DIR"
fi

# Clonamos específicamente el fork de DJLougen y su rama rys-qwen35
git clone -b rys-qwen35 https://github.com/DJLougen/llama.cpp "$LLAMA_DIR"

cd "$LLAMA_DIR"

# Crear directorio de compilación
mkdir build && cd build

echo "🏗️ [3/3] Compilando para NVIDIA CUDA (Multi-GPU)..."
cmake .. -DGGML_CUDA=ON
cmake --build . --config Release -j $(nproc)

echo "✅ Instalación y compilación completadas con éxito."