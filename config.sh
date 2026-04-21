#!/bin/bash
# ==========================================
# CONFIGURACIÓN GLOBAL DEL SERVIDOR (ORNSTEIN RYS)
# ==========================================

# Rutas principales (Automáticas)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$BASE_DIR/models"
LLAMA_DIR="$BASE_DIR/llama.cpp"
LOG_FILE="$BASE_DIR/server.log"

# Configuración del Modelo: Ornstein 3.6 35B RYS-SABER (Lógica duplicada + Uncensored)
# Cuantización: Q4_K_M (Alta precisión, ~21GB de peso)
MODEL_URL="https://huggingface.co/DJLougen/Ornstein3.6-35B-A3B-RYS-SABER-GGUF/resolve/main/Ornstein3.6-35B-A3B-RYS-SABER-Q4_K_M.gguf?download=true"
MODEL_FILENAME="Ornstein-35B-RYS-SABER.gguf"

# Parámetros de Inferencia (Optimizados para 2x RTX 3090 = 48GB VRAM)
CONTEXT_SIZE=196608    # 192k de contexto (Estable y masivo)
THREADS=16             # Hilos de CPU (Núcleos físicos del Ryzen 9 3950X)
BATCH_SIZE=2048        # Tamaño del bloque de lectura (Prompt Processing)
PORT=8080              # Puerto interno

# Monitor de Auto-Apagado
IDLE_TIMEOUT=1800      # 30 minutos sin uso apaga el servidor