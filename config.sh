#!/bin/bash
# ==========================================
# CONFIGURACIÓN GLOBAL (Unified)
# ==========================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$BASE_DIR/models"
LLAMA_DIR="$BASE_DIR/llama.cpp"
LOG_FILE="$BASE_DIR/server.log"
PID_FILE="$BASE_DIR/server.pid"

MODEL_URL="https://huggingface.co/HauhauCS/Qwen3.6-27B-Uncensored-HauhauCS-Aggressive/resolve/main/Qwen3.6-27B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf?download=true"
MODEL_FILENAME="Qwen3.6-27B-Uncensored.gguf"

VISION_MODEL_URL="https://huggingface.co/HauhauCS/Qwen3.6-27B-Uncensored-HauhauCS-Aggressive/resolve/main/mmproj-Qwen3.6-27B-Uncensored-HauhauCS-Aggressive-f16.gguf?download=true"
VISION_MODEL_FILENAME="mmproj-F16.gguf"

CTX_CHECKPOINTS=72
CXT_SIZE=262144
BATCH_SIZE=1024
PORT=8080
API_KEY="master-api-key-enok1111"
IDLE_TIMEOUT=1800
# --- Parámetros de Inferencia ---
TEMPERATURE=0.6
TOP_K=40
TOP_P=0.95
MIN_P=0.05
REPEAT_PENALTY=1.0

# Detección automática del binario de llama-server
if [ -f "/app/llama-server" ]; then
    SERVER_BIN="/app/llama-server" # Path en la imagen Docker de ghcr.io
elif [ -f "$LLAMA_DIR/build/bin/llama-server" ]; then
    SERVER_BIN="$LLAMA_DIR/build/bin/llama-server" # Path local compilado
else
    SERVER_BIN="llama-server" # Esperar que esté en el PATH
fi