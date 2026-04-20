#!/bin/bash
# ==========================================
# CONFIGURACIÓN GLOBAL DEL SERVIDOR
# ==========================================

# Rutas principales (Automáticas)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$BASE_DIR/models"
LLAMA_DIR="$BASE_DIR/llama.cpp"
LOG_FILE="$BASE_DIR/server.log"

# Configuración del Modelo
MODEL_URL="https://huggingface.co/HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive/resolve/main/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf?download=true"
MODEL_FILENAME="Qwen35B.gguf"

# Parámetros de Inferencia (Optimizados para 2x RTX 3090 = 48GB VRAM)
CONTEXT_SIZE=131072    # 131k de contexto
THREADS=16             # Hilos de CPU (Igual a núcleos físicos)
BATCH_SIZE=2048        # Tamaño del bloque de lectura
PORT=8080              # Puerto interno (Clore lo mapeará a otro)

# Monitor de Auto-Apagado
IDLE_TIMEOUT=1800      # 30 minutos sin uso apaga el servidor
