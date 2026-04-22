#!/bin/bash
# ==========================================
# CONFIGURACIÓN GLOBAL (SINGLE 3090 - QWEN 3.6 27B)
# ==========================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$BASE_DIR/models"
LLAMA_DIR="$BASE_DIR/llama.cpp"
LOG_FILE="$BASE_DIR/server.log"

# Modelo Qwen 3.6 27B (Q4_K_M, ~16 GB)
MODEL_URL="https://huggingface.co/Jackrong/Qwen3.6-27B-GGUF/resolve/main/Qwen3.6-27B-Q4_K_M.gguf?download=true"
MODEL_FILENAME="Qwen3.6-27B.gguf"

# Parámetros para Single GPU (24GB) con 192k de contexto
CONTEXT_SIZE=196608    # 192k de contexto
THREADS=12             # Hilos ajustados a los 12 núcleos físicos del Ryzen 3900
BATCH_SIZE=1024        # Lote de ingesta seguro para 24GB VRAM
PORT=8080
API_KEY="master-api-key-enok1111"

# Parámetros de Inferencia
TEMPERATURE=0.6
TOP_P=0.90
TOP_K=20
MIN_P=0.05

IDLE_TIMEOUT=1800