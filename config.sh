#!/bin/bash
# ==========================================
# CONFIGURACIÓN GLOBAL DEL SERVIDOR (SINGLE 3090 - RAM OFFLOAD)
# ==========================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$BASE_DIR/models"
LLAMA_DIR="$BASE_DIR/llama.cpp"
LOG_FILE="$BASE_DIR/server.log"

# Modelo Qwen 3.6 35B Uncensored (Q4_K_P)
MODEL_URL="https://huggingface.co/HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive/resolve/main/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf?download=true"
MODEL_FILENAME="Qwen35B.gguf"
API_KEY="sk-1234567890"

# Parámetros para Single GPU (24GB) con Offload a RAM
CONTEXT_SIZE=196608    # 192k de contexto
THREADS=12             # Hilos ajustados a los 12 núcleos físicos del Ryzen 3900
BATCH_SIZE=1024        # Reducido a 1024 para evitar desbordes de memoria en la ingesta
PORT=8080

IDLE_TIMEOUT=1800