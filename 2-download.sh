#!/bin/bash
source "$(dirname "$0")/config.sh"

mkdir -p "$MODELS_DIR"

echo "📥 Descargando modelo: $MODEL_FILENAME"
echo "URL: $MODEL_URL"

# aria2c usa 16 conexiones simultáneas para máxima velocidad
aria2c -x 16 -s 16 "$MODEL_URL" -d "$MODELS_DIR" -o "$MODEL_FILENAME"

if [[ "$*" == *"--vision"* ]]; then
    echo "📥 Descargando proyector de visión: $VISION_MODEL_FILENAME"
    aria2c -x 16 -s 16 "$VISION_MODEL_URL" -d "$MODELS_DIR" -o "$VISION_MODEL_FILENAME"
fi

echo "✅ Descarga completada."
