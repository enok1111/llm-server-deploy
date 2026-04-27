#!/bin/bash
source "$(dirname "$0")/config.sh"

mkdir -p "$MODELS_DIR"

if [ -f "$MODELS_DIR/$MODEL_FILENAME" ]; then
    echo "⏭️ El modelo $MODEL_FILENAME ya existe. Saltando descarga."
else
    echo "📥 Descargando modelo: $MODEL_FILENAME"
    echo "URL: $MODEL_URL"
    # aria2c usa 16 conexiones simultáneas para máxima velocidad
    # -c permite reanudar, --auto-file-renaming=false evita duplicados .1, .2
    aria2c -x 16 -s 16 -c --auto-file-renaming=false "$MODEL_URL" -d "$MODELS_DIR" -o "$MODEL_FILENAME"
fi

if [[ "$*" == *"--vision"* ]]; then
    if [ -f "$MODELS_DIR/$VISION_MODEL_FILENAME" ]; then
        echo "⏭️ El proyector de visión $VISION_MODEL_FILENAME ya existe. Saltando descarga."
    else
        echo "📥 Descargando proyector de visión: $VISION_MODEL_FILENAME"
        aria2c -x 16 -s 16 -c --auto-file-renaming=false "$VISION_MODEL_URL" -d "$MODELS_DIR" -o "$VISION_MODEL_FILENAME"
    fi
fi

echo "✅ Descarga completada."
