#!/bin/bash
# ==========================================
# CONFIGURACIÓN GLOBAL (Unified)
# ==========================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$BASE_DIR/models"
LLAMA_DIR="$BASE_DIR/llama.cpp"
LOG_FILE="$BASE_DIR/server.log"
PID_FILE="$BASE_DIR/server.pid"

MODEL_URL="https://huggingface.co/empero-ai/Qwythos-9B-Claude-Mythos-5-1M-GGUF/resolve/main/Qwythos-9B-Claude-Mythos-5-1M-MTP-Q5_K_M.gguf?download=true"
MODEL_FILENAME="Qwythos-9B-MTP.gguf"

VISION_MODEL_URL="https://huggingface.co/empero-ai/Qwythos-9B-Claude-Mythos-5-1M-GGUF/resolve/main/mmproj-Qwythos-9B-Claude-Mythos-5-1M-F16.gguf?download=true"
VISION_MODEL_FILENAME="mmproj-F16.gguf"

CTX_CHECKPOINTS=48
CXT_SIZE=262144
BATCH_SIZE=2048
PORT=8080
API_KEY="master-api-key-enok1111"
IDLE_TIMEOUT=1800

# --- Perfiles de Sampling ---
# Opciones: general, coding, coding_heavy, thinking_plus, instruct
SAMPLING_PROFILE="${SAMPLING_PROFILE:-coding_plus}"

# --- Thinking Mode Default (will be adjusted by profile) ---
DEFAULT_THINKING=true

# --- Configuración de Parámetros por Perfil ---
case "$SAMPLING_PROFILE" in
    "general")
        # Thinking mode (default) — general tasks
        TEMPERATURE=1.0
        TOP_K=20
        TOP_P=0.95
        MIN_P=0.0
        REPEAT_PENALTY=1.0
        PRESENCE_PENALTY=0.0
        ;;
    "coding")
        # Thinking mode — precise coding / WebDev (README exact)
        TEMPERATURE=0.6
        TOP_K=20
        TOP_P=0.95
        MIN_P=0.0
        REPEAT_PENALTY=1.0
        PRESENCE_PENALTY=0.0
        ;;
    "coding_plus")
        # Precise coding + README Author personal preference (Presence 1.5)
        TEMPERATURE=0.6
        TOP_K=20
        TOP_P=0.95
        MIN_P=0.0
        REPEAT_PENALTY=1.0
        PRESENCE_PENALTY=1.5
        ;;
    "thinking_plus")
        # README Author preference: Presence 1.5 to rein in thinking
        TEMPERATURE=1.0
        TOP_K=20
        TOP_P=0.95
        MIN_P=0.0
        REPEAT_PENALTY=1.0
        PRESENCE_PENALTY=1.5
        ;;
    "instruct")
        # Non-thinking (Instruct) mode
        TEMPERATURE=0.7
        TOP_K=20
        TOP_P=0.80
        MIN_P=0.0
        REPEAT_PENALTY=1.0
        PRESENCE_PENALTY=1.5
        DEFAULT_THINKING=false
        ;;
esac

# Final decision on thinking mode: CLI/Env > Profile Default
ENABLE_THINKING="${ENABLE_THINKING:-$DEFAULT_THINKING}"

# Detección automática del binario de llama-server
if [ -f "/app/llama-server" ]; then
    SERVER_BIN="/app/llama-server" # Path en la imagen Docker de ghcr.io
elif [ -f "$LLAMA_DIR/build/bin/llama-server" ]; then
    SERVER_BIN="$LLAMA_DIR/build/bin/llama-server" # Path local compilado
else
    SERVER_BIN="llama-server" # Esperar que esté en el PATH
fi