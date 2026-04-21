#!/bin/bash
# ==========================================
# CONFIGURACIÓN GLOBAL DEL SERVIDOR (SINGLE 3090 - RAM OFFLOAD)
# ==========================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$BASE_DIR/models"
LLAMA_DIR="$BASE_DIR/llama.cpp"
LOG_FILE="$BASE_DIR/server.log"

# Modelo Ornstein 3.6 35B RYS-SABER (Q4_K_M)
MODEL_URL="https://huggingface.co/DJLougen/Ornstein3.6-35B-A3B-RYS-SABER-GGUF/resolve/main/Ornstein3.6-35B-A3B-RYS-SABER-Q4_K_M.gguf?download=true"
MODEL_FILENAME="Ornstein-35B-RYS-SABER.gguf"

# Parámetros para Single GPU (24GB) con Offload a RAM
CONTEXT_SIZE=196608    # 192k de contexto
THREADS=12             # Hilos ajustados a los 12 núcleos físicos del Ryzen 3900
BATCH_SIZE=1024        # Reducido a 1024 para evitar desbordes de memoria en la ingesta
PORT=8080

IDLE_TIMEOUT=1800