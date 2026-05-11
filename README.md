# 🐳 n8n Docker Lab

Laboratorio didáctico para aprender Docker usando n8n como campo de práctica.
Diseñado para correr en **GitHub Codespaces** sin instalar absolutamente nada en tu computadora.

---

## ¿Para quién es este lab?

Para equipos de tecnología que conocen la consola pero nunca usaron Docker.
Si sabés qué es un `show run` o un `ping`, este lab habla tu idioma.

---

## ¿Por qué GitHub Codespaces?

Porque Docker **ya viene instalado**. Abrís el Codespace y en dos minutos estás corriendo contenedores. Sin instalar, sin configurar, sin "en mi máquina funciona".

→ Más detalle en [Módulo 00](modulos/00-por-que-codespaces/README.md)

---

## Mapa del laboratorio

| Módulo | Tema | Lo que vas a poder hacer |
|--------|------|--------------------------|
| [00](modulos/00-por-que-codespaces/README.md) | Por qué Codespaces | Abrir el entorno y verificar Docker |
| [01](modulos/01-hello-docker/README.md) | Hello Docker | Correr tu primer contenedor y entender qué pasó |
| [02](modulos/02-imagenes-contenedores/README.md) | Imágenes y contenedores | Entender la diferencia (como IOS vs router) |
| [03](modulos/03-volumenes-redes/README.md) | Volúmenes y redes | Persistir datos y comunicar contenedores |
| [04](modulos/04-n8n-un-comando/README.md) | n8n en un comando | n8n corriendo en 30 segundos |
| [05](modulos/05-n8n-compose/README.md) | n8n + PostgreSQL | Stack completo con docker-compose |
| [06](modulos/06-workflows/README.md) | Workflows de ejemplo | Importar y probar automatizaciones reales |

---

## Cómo arrancar

### Opción A — GitHub Codespaces (recomendada)

1. Hacé clic en el botón verde **`<> Code`** arriba a la derecha
2. Elegí la pestaña **Codespaces**
3. Clic en **Create codespace on master**
4. Esperás ~1 minuto mientras carga el entorno
5. Verificás que Docker funciona:

```bash
docker --version
```

Deberías ver algo como `Docker version 24.x.x` — eso es todo, estás listo.

### Opción B — Local (si ya tenés Docker instalado)

```bash
git clone https://github.com/Mauroquil-bit/n8n_docker_lab.git
cd n8n_docker_lab
docker --version
```

---

## Atajos útiles (Makefile)

```bash
make n8n-start    # Levanta n8n con docker-compose
make n8n-stop     # Detiene n8n
make n8n-logs     # Ve los logs en tiempo real
make n8n-clean    # Borra contenedores y volúmenes (reset completo)
make help         # Lista todos los comandos disponibles
```

---

## Referencia rápida

¿Buscás un comando Docker específico? → [cheatsheet.md](cheatsheet.md)

---

## Orden sugerido

Seguí los módulos en orden la primera vez. Después podés saltar al que necesites como referencia.

```
00 → 01 → 02 → 03 → 04 → 05 → 06
```

Cada módulo es independiente y tiene sus propios ejercicios con solución.

## ¿Por qué armé este lab?

Hice un curso interno en mi trabajo donde varios compañeros no 
terminaron de captar la parte práctica. Como yo ya había trabajado 
con Docker antes, me pidieron que les explicara. En vez de armar 
una clase, preferí dejarles algo reproducible: un Codespace que 
funciona en 2 minutos y módulos que pueden hacer a su ritmo.

Lo aceleré usando Claude Code como copiloto — la arquitectura, los 
módulos didácticos y las decisiones de stack son mías; la IA me 
ayudó con la escritura del docker-compose, los Makefiles y la 
documentación.

## ⚡ Comandos rápidos del lab

Este repositorio incluye un `Makefile` con atajos para los comandos más usados. Desde la raíz del repo, ejecutá:

```bash
make help
```

Vas a ver algo como:

```
Comandos disponibles:

  n8n-start            Levantar n8n + PostgreSQL en background
  n8n-stop             Detener n8n (mantiene los datos)
  n8n-logs             Ver logs en tiempo real (Ctrl+C para salir)
  n8n-status           Ver estado de los servicios
  n8n-restart          Reiniciar solo n8n (sin tocar postgres)
  n8n-clean            Borrar contenedores Y volúmenes (reset total)
  ps                   Ver todos los contenedores corriendo
  ps-all               Ver todos los contenedores (incluye detenidos)
  images               Ver imágenes descargadas
  clean-containers     Borrar todos los contenedores detenidos
  clean-all            Borrar contenedores detenidos, imágenes sin uso y volúmenes huérfanos
```

### Comandos más usados

| Comando | Qué hace |
|---------|----------|
| `make n8n-start` | Levanta n8n + PostgreSQL |
| `make n8n-logs` | Ver qué está pasando |
| `make n8n-stop` | Apagar (conserva datos) |
| `make n8n-clean` | Apagar y **borrar todo** |

> 💡 No es obligatorio usar el `Makefile`. Todos los comandos están explicados manualmente en cada módulo del curso.
