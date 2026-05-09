# Módulo 04 — n8n en un Comando

## ¿Qué es n8n?

n8n es una plataforma de automatización de workflows con interfaz visual. Podés conectar servicios, APIs, bases de datos y lógica sin escribir código (o escribiendo poco).

Corre como una aplicación web. En este módulo la levantamos con un solo comando Docker.

---

## Levantando n8n

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  n8nio/n8n
```

Esperá ~20 segundos y abrí en el navegador: `http://localhost:5678`

En Codespaces, aparecerá una notificación para abrir el puerto. Hacé clic en **Open in Browser**.

---

## ¿Qué hace cada parte del comando?

```bash
docker run          # Crear y correr un contenedor
  -d                # En background (detached)
  --name n8n        # Nombre del contenedor
  -p 5678:5678      # Puerto host:contenedor (NAT)
  -v n8n_data:/home/node/.n8n   # Volumen para persistir workflows
  n8nio/n8n         # Imagen oficial de n8n
```

---

## Primera vez que abrís n8n

La primera vez te pide crear una cuenta de administrador **local** (no es una cuenta de internet, es solo para este n8n).

1. Completá nombre, email y contraseña
2. Entrás al dashboard de n8n
3. Podés crear workflows desde cero o importar los del Módulo 06

---

## Comandos útiles

```bash
# Ver que está corriendo
docker ps

# Ver los logs de n8n en tiempo real
docker logs -f n8n

# Detener n8n
docker stop n8n

# Volver a levantarlo (los workflows se mantienen por el volumen)
docker start n8n

# Borrar el contenedor (los workflows se mantienen en el volumen)
docker rm n8n

# Borrar TODO incluyendo los workflows
docker rm n8n && docker volume rm n8n_data
```

---

## Verificar que los datos persisten

```bash
# 1. Crear un workflow en n8n (cualquiera, aunque sea vacío)
# 2. Detener y borrar el contenedor
docker stop n8n && docker rm n8n

# 3. Volver a crear el contenedor con el mismo volumen
docker run -d --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n n8nio/n8n

# 4. Abrir n8n — el workflow sigue ahí
```

Esto demuestra que el volumen `n8n_data` guarda los datos independientemente del contenedor.

---

## Limitación de esta configuración

Esta versión usa **SQLite** como base de datos (un archivo dentro del volumen). Es perfecta para aprender y para uso personal, pero no escala bien para producción o para equipos.

Para producción usamos **PostgreSQL** — eso lo vemos en el Módulo 05.

---

## Checkpoint ✓

1. ¿Por qué necesitamos el flag `-v n8n_data:/home/node/.n8n`?
2. ¿Qué pasa si hacés `docker rm n8n` sin el flag `-v`?
3. ¿Cómo verías los logs de n8n en tiempo real?

<details>
<summary>Ver respuestas</summary>

1. Para que los workflows, credenciales y configuración de n8n persistan aunque borremos el contenedor. Sin ese volumen, todo se pierde al hacer `docker rm`.
2. El contenedor se borra pero el volumen `n8n_data` sigue existiendo. Si creás otro contenedor con el mismo volumen, los datos siguen ahí.
3. `docker logs -f n8n` — el flag `-f` hace "follow", como `tail -f` en Linux.

</details>

---

→ [Módulo 05 — n8n con Docker Compose](../05-n8n-compose/README.md)
