# 🚀 LLM Server Deploy Pro

Despliegue optimizado de modelos **Qwen 27B** con **llama.cpp**. Este repositorio detecta automáticamente si estás en una instancia limpia (Bare Metal) o en una instancia de **Clore.ai** con la imagen oficial de `llama.cpp`.

## 🚀 Uso Unificado (Unified Workflow)

Este repositorio ahora soporta múltiples perfiles de modelo siguiendo las mejores prácticas **DRY**.

### 1. Preparar Entorno (Solo una vez)
Detecta automáticamente tu OS (Linux/CUDA o Mac/Metal) y compila/instala lo necesario.
```bash
./1-install.sh
```

### 2. Descargar Modelos
Puedes descargar el modelo estándar o el perfil VL (Visión).
*   **Estándar (Qwen 27B):** `./2-download.sh`
*   **Visión (Qwen2.5-VL 3B):** `./2-download.sh --vl`

### 3. Lanzar Servidor y Monitor
Arranca el servidor en segundo plano con monitoreo de inactividad automático.
*   **Estándar:** `./3-run.sh`
*   **Visión:** `./3-run.sh --vl`

---

## ✨ Características Técnicas (Unified)

- **🔄 Perfiles Inteligentes:** Configuración centralizada en `config.sh`.
- **🖥️ Soporte Multi-Plataforma:** Apple Silicon (Metal) y NVIDIA (CUDA) detectados automáticamente.
- **⏱️ Monitor Universal:** `src/monitor.sh` protege tu RAM/Créditos en ambos perfiles.
- **⚡ Descarga Acelerada:** Uso de `aria2c` con fallback a `curl`.

---

## ⚙️ Configuración (`config.sh`)

| Variable | Propósito | Valor por Defecto |
| :--- | :--- | :--- |
| `MODEL_PROFILE` | Perfil activo | `QWEN_27B` o `QWEN_VL_3B` |
| `API_KEY` | Clave de seguridad | `master-api-key-enok1111` |
| `IDLE_TIMEOUT` | Auto-apagado (seg) | 1800 (30 min) |
| `TEMPERATURE` | Creatividad (0-1.5) | 0.6 |
| `TOP_P` | Nucleus Sampling | 0.95 |
| `MIN_P` | Min Probability | 0.1 |
| `TOP_K` | Top K tokens | 40 |
| `REPEAT_PENALTY` | Penalización Rep. | 1.0 |

### 🆕 Nuevos Parámetros de Ejecución (`3-run.sh`)

Ahora puedes pasar parámetros directamente al ejecutar:
```bash
./3-run.sh --vl --temp 0.8 --top-p 0.9
```

## 📊 Mantenimiento y Logs

- **Ver Inferencia:** `tail -f server.log`
- **Ver Monitor:** `tail -f monitor.log`
- **Detener Todo:** `pkill -f llama-server && pkill -f monitor.sh`

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
