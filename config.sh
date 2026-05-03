#!/bin/bash
# ==========================================
# CONFIGURACIÓN GLOBAL
# ==========================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$BASE_DIR/models"
LLAMA_DIR="$BASE_DIR/llama.cpp"
LOG_FILE="$BASE_DIR/server.log"

MODEL_URL="https://huggingface.co/unsloth/Qwen3.6-27B-GGUF/resolve/main/Qwen3.6-27B-Q4_K_M.gguf?download=true"
MODEL_FILENAME="Qwen3.6-27B.gguf"

VISION_MODEL_URL="https://huggingface.co/unsloth/Qwen3.6-27B-GGUF/resolve/main/mmproj-BF16.gguf?download=true"
VISION_MODEL_FILENAME="mmproj-BF16.gguf"

CTX_CHECKPOINTS=128
CXT_SIZE=229376
BATCH_SIZE=2048
PORT=8080
API_KEY="master-api-key-enok1111"

IDLE_TIMEOUT=1800

# Detección automática del binario de llama-server
if [ -f "/app/llama-server" ]; then
    SERVER_BIN="/app/llama-server" # Path en la imagen Docker de ghcr.io
elif [ -f "$LLAMA_DIR/build/bin/llama-server" ]; then
    SERVER_BIN="$LLAMA_DIR/build/bin/llama-server" # Path local compilado
else
    SERVER_BIN="llama-server" # Esperar que esté en el PATH
fi