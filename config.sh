#!/bin/bash
# ==========================================
# CONFIGURACIÓN GLOBAL (Unified)
# ==========================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$BASE_DIR/models"
LLAMA_DIR="$BASE_DIR/llama.cpp"
LOG_FILE="$BASE_DIR/server.log"
PID_FILE="$BASE_DIR/server.pid"

MODEL_URL="https://huggingface.co/DavidAU/Qwen3.6-27B-Heretic-Uncensored-FINETUNE-NEO-CODE-Di-IMatrix-MAX-GGUF/resolve/main/Qwen3.6-27B-NEO-CODE-HERE-2T-OT-Q4_K_M.gguf?download=true"
MODEL_FILENAME="Qwen3.6-27B-Heretic.gguf"

VISION_MODEL_URL="https://huggingface.co/DavidAU/Qwen3.6-27B-Heretic-Uncensored-FINETUNE-NEO-CODE-Di-IMatrix-MAX-GGUF/resolve/main/mmproj-BF16.gguf?download=true"
VISION_MODEL_FILENAME="mmproj-BF16.gguf"

CTX_CHECKPOINTS=48
CXT_SIZE=196608
BATCH_SIZE=1024
PORT=8080
API_KEY="master-api-key-enok1111"
IDLE_TIMEOUT=1800
# --- Parámetros de Inferencia ---
TEMPERATURE=0.7
TOP_P=0.95
MIN_P=0.1
TOP_K=40
REPEAT_PENALTY=1.1

# Detección automática del binario de llama-server
if [ -f "/app/llama-server" ]; then
    SERVER_BIN="/app/llama-server" # Path en la imagen Docker de ghcr.io
elif [ -f "$LLAMA_DIR/build/bin/llama-server" ]; then
    SERVER_BIN="$LLAMA_DIR/build/bin/llama-server" # Path local compilado
else
    SERVER_BIN="llama-server" # Esperar que esté en el PATH
fi