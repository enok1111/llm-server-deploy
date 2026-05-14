# 🚀 LLM Server Deploy Pro (Heretic Uncensored Branch)

Despliegue optimizado del modelo **Qwen3.6 27B Heretic Uncensored** con **llama.cpp**. Este repositorio detecta automáticamente si estás en una instancia limpia (Bare Metal) o en una instancia de **Clore.ai** con la imagen oficial de `llama.cpp`.

## 🚀 Uso Unificado (Unified Workflow)

Este perfil está configurado para:
*   **Modelo:** Qwen3.6-27B-Heretic-Uncensored (DavidAU)
*   **Quant:** Q4_K_M (Di-IMatrix)
*   **Hardware:** 1x RTX 3090/4090 (24GB VRAM)

### 1. Preparar Entorno (Solo una vez)
```bash
./1-install.sh
```

### 2. Descargar Modelos
*   **Estándar:** `./2-download.sh`
*   **Visión:** `./2-download.sh --vision` (Descarga el proyector mmproj)

### 3. Lanzar Servidor
Arranca el servidor en segundo plano.
*   **Estándar:** `./3-run.sh`
*   **Visión:** `./3-run.sh --vision`

---

## ✨ Características Técnicas (Unified)

- **🔄 Perfiles Inteligentes:** Configuración centralizada en `config.sh`.
- **🖥️ Soporte Multi-Plataforma:** Apple Silicon (Metal) y NVIDIA (CUDA) detectados automáticamente.
- **⚡ Descarga Acelerada:** Uso de `aria2c` con fallback a `curl`.

---

## ⚙️ Configuración (`config.sh`)

| Variable | Propósito | Valor por Defecto |
| :--- | :--- | :--- |
| `MODEL_PROFILE` | Perfil activo | `QWEN_27B` o `QWEN_VL_3B` |
| `API_KEY` | Clave de seguridad | `master-api-key-enok1111` |
| `TEMPERATURE` | Creatividad (0-1.5) | 0.6 |
| `TOP_P` | Nucleus Sampling | 0.95 |
| `MIN_P` | Min Probability | 0.1 |
| `TOP_K` | Top K tokens | 40 |
| `REPEAT_PENALTY` | Penalización Rep. | 1.0 |

### 🆕 Nuevos Parámetros de Ejecución (`3-run.sh`)

Now puedes pasar parámetros directamente al ejecutar:
```bash
./3-run.sh --vl --temp 0.8 --top-p 0.9
```

## 📊 Mantenimiento y Logs

- **Ver Inferencia:** `tail -f server.log`
- **Detener Todo:** `pkill -f llama-server`
