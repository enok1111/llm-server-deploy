# 🚀 LLM Server Deploy Pro (Heretic Uncensored Branch)

Despliegue optimizado del modelo **Qwen3.6 27B Heretic Uncensored** con **llama.cpp**. Este repositorio detecta automáticamente si estás en una instancia limpia (Bare Metal) o en una instancia de **Clore.ai** con la imagen oficial de `llama.cpp`.

## 🚀 Uso Unificado (Unified Workflow)

Este perfil está configurado para:

* **Modelo:** Qwen3.6-27B-Heretic-Uncensored (DavidAU)
* **Quant:** Q4_K_M (Di-IMatrix)
* **Hardware:** 1x RTX 3090/4090 (24GB VRAM)

### 1. Preparar Entorno (Solo una vez)

```bash
git clone https://github.com/enok1111/llm-server-deploy.git
cd llm-server-deploy
git checkout qwen3.6-27b-uncesored
./1-install.sh
```

### 2. Descargar Modelos

* **Estándar:** `./2-download.sh`
* **Visión:** `./2-download.sh --vision` (Descarga el proyector mmproj)

### 3. Lanzar Servidor

Arranca el servidor en segundo plano.

* **Estándar:** `./3-run.sh`
* **Visión:** `./3-run.sh --vision`
* **Con Perfil:** `./3-run.sh --profile coding`
* **Sin Pensamiento:** `./3-run.sh --no-thinking`

---

## ✨ Características Técnicas (Unified)

* **🔄 Perfiles Inteligentes:** Configuración centralizada en `config.sh` y personalizable vía CLI.
* **🖥️ Soporte Multi-Plataforma:** Apple Silicon (Metal) y NVIDIA (CUDA) detectados automáticamente.
* **⚡ Descarga Acelerada:** Uso de `aria2c` con fallback a `curl`.

---

## ⚙️ Configuración (`config.sh` & CLI)

La configuración principal se gestiona en `config.sh`. Hemos implementado **Perfiles de Sampling** para optimizar el modelo según el caso de uso. Los parámetros pueden sobrescribirse mediante flags al ejecutar `./3-run.sh`.

### 🎭 Perfiles de Sampling (`--profile`)

| Perfil | Descripción | Parámetros Clave |
| :--- | :--- | :--- |
| `general` | Balanceado para tareas generales. | Temp 1.0, Thinking ON |
| `coding` | Optimizado para programación exacta. | Temp 0.6, Rep. Penalty 1.0 |
| `coding_plus` | (Default) Programación + Estilo Autor. | Temp 0.6, Pres. Penalty 1.5 |
| `thinking_plus` | Optimizado para razonamiento profundo. | Temp 1.0, Pres. Penalty 1.5 |
| `instruct` | Modo tradicional sin pensamiento. | Thinking OFF, Pres. 1.5 |

### 🧠 Control de Pensamiento (`--thinking` / `--no-thinking`)

| Flag | Propósito |
| :--- | :--- |
| `--thinking` | Fuerza la activación del razonamiento interno. |
| `--no-thinking` | Desactiva el razonamiento (Modo fast/instruct). |

### 🔧 Otros Flags de Ejecución

| Flag | Propósito | Ejemplo |
| :--- | :--- | :--- |
| `--port` | Cambia el puerto del servidor. | `./3-run.sh --port 9000` |
| `--vision` | Carga el modelo de visión (VL). | `./3-run.sh --vision` |

---

## 📊 Mantenimiento y Logs

* **Ver Inferencia:** `tail -f server.log`
* **Detener Todo:** `pkill -f llama-server`
