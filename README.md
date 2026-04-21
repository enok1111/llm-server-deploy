# 🚀 LLM Server Deploy Pro (Qwen 35B / llama.cpp)

Este repositorio es una solución de despliegue de alto rendimiento para servir modelos de lenguaje masivos con soporte nativo para infraestructuras Multi-GPU (NVIDIA CUDA). Optimizado específicamente para configuraciones de alta densidad como 2x RTX 3090/4090 (48GB VRAM).

## 🏗️ Arquitectura del Sistema

El despliegue se divide en tres capas desacopladas gestionadas por scripts modulares:

1. **Capa de Entorno:** Aprovisionamiento de dependencias críticas (`nvcc`, `cmake`, `aria2`).
2. **Capa de Motor:** Compilación JIT de `llama.cpp` optimizada con flags `GGML_CUDA=ON`.
3. **Capa de Orquestación:** Gestión de procesos (`llama-server`) y watchdog de inactividad dinámico (`monitor.sh`).

---

## ⚙️ Guía de Despliegue Avanzado

### 1. Clonación y Preparación

```bash
git clone https://github.com/enok1111/llm-server-deploy.git
cd llm-server-deploy && chmod +x *.sh src/*.sh
```

### 2. Compilación Optimizada

El script `./1-install.sh` detecta automáticamente la topología de tu CPU y compila el motor con soporte para **Unified Memory y Peer-to-Peer** entre GPUs.

```bash
./1-install.sh
```

### 3. Ingesta de Datos (High-Speed)

Utilizamos `aria2c` con segmentación de 16 conexiones para saturar el ancho de banda del datacenter.

```bash
./2-download.sh
```

### 4. Lanzamiento con Motor de Inferencia Optimizado

El servidor arranca con las siguientes optimizaciones activas:

- **Flash Attention (FA):** Reducción de la complejidad cuadrática en contextos largos.
- **KV Cache Quantization (`q8_0`):** Mantenemos alta precisión en la ventana de 131k tokens sin desbordar la VRAM.
- **Idle Watchdog:** Monitorización de slots HTTP para auto-terminación de instancia tras inactividad.

```bash
./3-run.sh
```

---

## 📊 Diagnóstico y Rendimiento

### Monitoreo de VRAM y Balanceo

Para verificar que el modelo está correctamente repartido entre los dispositivos CUDA:

```bash
watch -n 1 nvidia-smi
```

### Análisis de Logs de Inferencia

```bash
tail -f server.log | grep --line-buffered "slot"
```

### Estado del Vigilante (Watchdog)

```bash
tail -f monitor.log
```

---

## 🛠️ Ajustes de Ingeniería (config.sh)

| Parámetro | Descripción | Valor Recomendado |
| :--- | :--- | :--- |
| `CONTEXT_SIZE` | Ventana de contexto máxima | 131072 (128k) |
| `THREADS` | Hilos de CPU (OMP_NUM_THREADS) | Núcleos físicos |
| `IDLE_TIMEOUT` | Tiempo para auto-apagado | 1800 (30 min) |
| `BATCH_SIZE` | Procesamiento paralelo de tokens | 2048 |

---

## 🛡️ Resolución de Problemas (Troubleshooting)

- **CUDA_ERROR_OUT_OF_MEMORY**: El modelo + contexto excede la VRAM. Reduce `CONTEXT_SIZE` o `BATCH_SIZE` en `config.sh`.
- **Baja Velocidad de Generación**: Verifica que las GPUs no estén en slots PCIe limitados (x1 o x4). Usa `lspci -vv` para confirmar el ancho de banda.
- **Limpieza Manual**: En caso de colisión de puertos, usa `pkill -9 llama-server`.
