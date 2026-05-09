# Módulo 05 — n8n con Docker Compose

## ¿Por qué Docker Compose?

En el módulo anterior levantamos n8n con un solo comando. Funciona, pero tiene una limitación: usa SQLite (un archivo de base de datos plano).

Para un entorno más robusto necesitamos:
- **PostgreSQL** como base de datos
- Que n8n y postgres se comuniquen en una red interna
- Que ambos arranquen juntos con un solo comando
- Variables de configuración separadas del código

Para eso existe **Docker Compose**: una herramienta para definir y correr aplicaciones multi-contenedor.

---

## Analogía: como un script de configuración

En Cisco, cuando querés configurar un equipo con múltiples interfaces, VLANs y rutas, no escribís cada comando a mano cada vez — usás un script o un template.

Docker Compose es ese script para contenedores. Define en un archivo YAML:
- Qué contenedores corren
- Cómo se conectan
- Qué volúmenes usan
- Qué variables de entorno tienen

---

## Estructura de archivos

```
modulos/05-n8n-compose/
├── docker-compose.yml    # La "receta" de toda la aplicación
├── .env.example          # Variables de entorno (sin valores sensibles)
└── README.md             # Este archivo
```

---

## Paso 1 — Preparar las variables de entorno

```bash
cd modulos/05-n8n-compose

# Copiar el archivo de ejemplo
cp .env.example .env

# Editar con tus valores (el archivo .env NO se sube a git)
nano .env
```

Contenido del `.env`:

```env
POSTGRES_USER=n8n
POSTGRES_PASSWORD=cambiame123
POSTGRES_DB=n8n_db
N8N_ENCRYPTION_KEY=una-clave-larga-y-aleatoria-min-24-chars
GENERIC_TIMEZONE=America/Argentina/Buenos_Aires
```

> **Importante:** Nunca subas el `.env` a GitHub. Ya está en el `.gitignore`.

---

## Paso 2 — Leer el docker-compose.yml

Abrí el archivo y leelo antes de correrlo. Cada sección tiene comentarios explicativos.

---

## Paso 3 — Levantar el stack

```bash
# Desde la carpeta 05-n8n-compose
docker compose up -d
```

Docker Compose va a:
1. Descargar las imágenes (postgres y n8n) si no las tenés
2. Crear la red interna `n8n-red`
3. Levantar postgres y esperar a que esté listo
4. Levantar n8n conectado a postgres

```bash
# Ver que ambos contenedores están corriendo
docker compose ps
```

```
NAME                STATUS          PORTS
05-n8n-compose-postgres-1   running   5432/tcp
05-n8n-compose-n8n-1        running   0.0.0.0:5678->5678/tcp
```

---

## Paso 4 — Abrir n8n

`http://localhost:5678` — igual que antes, pero ahora con PostgreSQL como backend.

---

## Comandos de Docker Compose

```bash
docker compose up -d          # Levantar en background
docker compose down           # Detener y borrar contenedores
docker compose down -v        # Detener + borrar volúmenes (reset total)
docker compose ps             # Estado de los servicios
docker compose logs -f        # Logs de todos los servicios
docker compose logs -f n8n    # Logs solo de n8n
docker compose restart n8n    # Reiniciar solo n8n
docker compose pull           # Actualizar imágenes
```

---

## Diferencia clave: `docker compose down` vs `docker compose down -v`

```bash
docker compose down      # Borra contenedores, mantiene volúmenes y datos
docker compose down -v   # Borra TODO incluyendo base de datos (reset completo)
```

Usá `down -v` solo cuando querés empezar de cero.

---

## Estructura del docker-compose.yml explicada

```yaml
services:        # Los "dispositivos" de tu red
  postgres:      # Servicio 1: base de datos
  n8n:           # Servicio 2: la aplicación

networks:        # Las "VLANs" internas
  n8n-red:

volumes:         # El almacenamiento persistente
  postgres_data:
  n8n_data:
```

---

## Checkpoint ✓

1. ¿Cuál es la ventaja de usar PostgreSQL en lugar de SQLite?
2. ¿Por qué n8n y postgres no necesitan mapeo de puertos entre ellos?
3. ¿Qué diferencia hay entre `docker compose down` y `docker compose down -v`?

<details>
<summary>Ver respuestas</summary>

1. PostgreSQL escala mejor, soporta conexiones concurrentes, tiene mejor rendimiento y es más adecuado para producción o equipos. SQLite es un archivo local sin soporte para concurrencia real.
2. Porque están en la misma red Docker interna (`n8n-red`) y se resuelven por nombre. El mapeo de puertos `-p` es solo para exponer servicios al exterior del host.
3. `docker compose down` detiene y borra los contenedores pero mantiene los volúmenes (datos). `docker compose down -v` también borra los volúmenes — todo se pierde, como un reset de fábrica.

</details>

---

→ [Módulo 06 — Workflows de ejemplo](../06-workflows/README.md)
