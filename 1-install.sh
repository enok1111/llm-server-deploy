#!/bin/bash
source "$(dirname "$0")/config.sh"

echo "🔍 Detectando entorno de ejecución..."

if [ -f "/app/llama-server" ]; then
    echo "🐳 Entorno Docker (Clore.ai) detectado. Omitiendo compilación."
    echo "📦 Instalando solo herramientas de soporte (aria2, procps)..."
    apt-get update && apt-get install -y aria2 procps
else
    echo "🖥️ Entorno Bare Metal detectado. Iniciando instalación completa..."
    apt-get update
    apt-get install -y build-essential cmake git libcurl4-openssl-dev libssl-dev aria2 nvidia-cuda-toolkit procps

    export PATH=/usr/local/cuda/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

    echo "📥 Descargando y preparando llama.cpp..."
    if [ -d "$LLAMA_DIR" ]; then rm -rf "$LLAMA_DIR"; fi
    git clone https://github.com/ggerganov/llama.cpp "$LLAMA_DIR"
    cd "$LLAMA_DIR" && mkdir build && cd build
    
    echo "🏗️ Compilando para NVIDIA CUDA..."
    cmake .. -DGGML_CUDA=ON
    cmake --build . --config Release -j $(nproc)
fi

echo "✅ Preparación completada."
