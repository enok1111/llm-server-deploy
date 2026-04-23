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

CONTEXT_SIZE=262144
BATCH_SIZE=1024
PORT=8080
API_KEY="master-api-key-enok1111"

IDLE_TIMEOUT=1800