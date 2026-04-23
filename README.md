# 🚀 LLM Server Deploy Pro

Despliegue optimizado de modelos **Qwen 27B** con **llama.cpp**. Este repositorio detecta automáticamente si estás en una instancia limpia (Bare Metal) o en una instancia de **Clore.ai** con la imagen oficial de `llama.cpp`.

## 🏗️ Flujo de Trabajo en Clore.ai

Si estás usando Clore.ai, sigue estos pasos para un despliegue en menos de 5 minutos:

1.  **Crear Instancia:** Selecciona la imagen `ghcr.io/ggml-org/llama.cpp:server-cuda13`.
2.  **Conectar y Clonar:**
    ```bash
    git clone https://github.com/enok1111/llm-server-deploy.git
    cd llm-server-deploy && chmod +x *.sh src/*.sh
    ```
3.  **Preparar Entorno:** Instala solo las herramientas de descarga y monitoreo (omite la compilación).
    ```bash
    ./1-install.sh
    ```
4.  **Descargar Modelo:**
    ```bash
    ./2-download.sh
    ```
5.  **Lanzar Servidor:**
    ```bash
    ./3-run.sh
    ```

---

## ✨ Características Técnicas

- **🔄 Detección Automática:** Los scripts detectan el binario `/app/llama-server` de la imagen Docker para evitar compilaciones innecesarias.
- **🚀 Ultra-Contexto:** Configurado por defecto para **256k tokens** con Flash Attention.
- **⏱️ Watchdog Inteligente:** Apagado automático del servidor tras inactividad para ahorrar crédito en Clore.ai.
- **⚡ Descarga Acelerada:** Uso de `aria2c` con 16 conexiones simultáneas.

---

## ⚙️ Configuración (`config.sh`)

Puedes personalizar los parámetros clave antes de ejecutar los scripts:

| Variable | Propósito | Valor por Defecto |
| :--- | :--- | :--- |
| `CONTEXT_SIZE` | Ventana de contexto máxima | 262144 (256k) |
| `API_KEY` | Clave de seguridad de la API | `master-api-key-enok1111` |
| `IDLE_TIMEOUT` | Tiempo de auto-apagado (segundos) | 1800 (30 min) |

---

## 💡 Recomendaciones de Hardware (Clore.ai)

- **GPU:** Mínimo **1x RTX 3090/4090** (24GB VRAM) para el modelo Q4_K_M.
- **Recomendado:** **2x RTX 3090/4090** para manejar contextos largos sin degradación de velocidad.
- **Drivers:** La imagen CUDA 13 requiere hosts con drivers **570.xx+**.

---

## 📊 Mantenimiento y Logs

- **Ver Inferencia:** `tail -f server.log`
- **Ver Monitor:** `tail -f monitor.log`
- **Detener Servidor:** `pkill -f llama-server && pkill -f monitor.sh`
