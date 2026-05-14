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

La configuración principal se gestiona en `config.sh`. Hemos implementado **Perfiles de Sampling** para optimizar el modelo según el caso de uso.

### 🎭 Perfiles de Sampling (`SAMPLING_PROFILE`)

| Perfil | Descripción | Parámetros Clave |
| :--- | :--- | :--- |
| `general` | (Default) Balanceado para tareas generales. | Temp 1.0, Thinking ON |
| `coding` | Optimizado para programación exacta (README). | Temp 0.6, Rep. Penalty 1.0 |
| `coding_plus` | Programación + Preferencia del Autor (Presencia). | Temp 0.6, Pres. Penalty 1.5 |
| `thinking_plus` | Optimizado para razonamiento con presencia 1.5. | Temp 1.0, Pres. Penalty 1.5 |
| `instruct` | Modo tradicional sin pensamiento (Fast). | Thinking OFF, Pres. 1.5 |

### 🧠 Control de Pensamiento (`ENABLE_THINKING`)

| Variable | Propósito | Valor |
| :--- | :--- | :--- |
| `ENABLE_THINKING` | Activa/Desactiva el razonamiento interno. | `true` / `false` |

### 🔧 Otras Variables

| Variable | Propósito | Valor por Defecto |
| :--- | :--- | :--- |
| `API_KEY` | Clave de seguridad | `master-api-key-enok1111` |
| `CXT_SIZE` | Tamaño de contexto | 262144 |
| `CTX_CHECKPOINTS`| Optimización de KV Cache | 32 |
| `PORT` | Puerto del servidor | 8080 |

---

## 📊 Mantenimiento y Logs

- **Ver Inferencia:** `tail -f server.log`
- **Detener Todo:** `pkill -f llama-server`
