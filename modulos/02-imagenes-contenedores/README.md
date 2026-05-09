# Módulo 02 — Imágenes y Contenedores

## La confusión más común

La primera vez que usás Docker, imagen y contenedor parecen la misma cosa. No lo son.

| | Imagen | Contenedor |
|--|--------|-----------|
| **Qué es** | Plantilla de solo lectura | Instancia en ejecución de una imagen |
| **Se modifica** | No (es inmutable) | Sí (tiene una capa de escritura) |
| **Analogía Cisco** | Archivo IOS en flash | Router corriendo ese IOS |
| **Cuántos podés tener** | Una imagen | Muchos contenedores de la misma imagen |
| **Dónde vive** | En disco | En memoria (mientras corre) |

---

## Docker Hub: el repositorio de imágenes

Docker Hub (`hub.docker.com`) es el repositorio público de imágenes. Es como un servidor TFTP en la nube donde están todos los IOS disponibles.

Cuando hacés `docker run nginx`, Docker:
1. Busca la imagen `nginx` localmente
2. Si no la encuentra, la baja de Docker Hub
3. Crea un contenedor a partir de esa imagen

### Ver imágenes disponibles en Docker Hub

```bash
docker search nginx
```

```
NAME                               DESCRIPTION                      STARS
nginx                              Official build of Nginx.         19000+
bitnami/nginx                      Bitnami nginx Docker Image       200+
...
```

### Descargar una imagen sin correrla

```bash
docker pull nginx
docker pull postgres:16
docker pull n8nio/n8n
```

El tag después de `:` es la versión. Si no ponés tag, descarga `latest`.

### Ver imágenes que tenés localmente

```bash
docker images
```

```
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
nginx        latest    a72860cb95fd   2 weeks ago    188MB
postgres     16        8e1e2e3a4f5a   3 weeks ago    432MB
n8nio/n8n    latest    b3c4d5e6f7a8   1 week ago     612MB
```

---

## Correr contenedores con opciones útiles

### Asignar un nombre al contenedor

```bash
docker run --name mi-nginx nginx
```

Sin `--name`, Docker le asigna un nombre aleatorio como `happy_turing` o `brave_einstein`.

### Correr en segundo plano (modo detached)

```bash
docker run -d --name mi-nginx nginx
```

El flag `-d` es como poner un proceso en background. El contenedor corre pero no te "traba" la terminal.

### Mapear puertos (como NAT en Cisco)

```bash
docker run -d --name mi-nginx -p 8080:80 nginx
```

`-p 8080:80` significa: **puerto 8080 del host → puerto 80 del contenedor**

Es exactamente como NAT: el tráfico que llega al 8080 externo se redirige al 80 interno del contenedor.

En Codespaces, al correr esto vas a ver una notificación para abrir el puerto en el navegador.

### Verificar que funciona

```bash
curl http://localhost:8080
```

Deberías ver el HTML de bienvenida de nginx.

---

## Ciclo de vida de un contenedor

```
docker pull     →  Imagen descargada
docker run      →  Contenedor CREADO y CORRIENDO
docker stop     →  Contenedor DETENIDO (sigue existiendo)
docker start    →  Contenedor CORRIENDO de nuevo
docker rm       →  Contenedor ELIMINADO
docker rmi      →  Imagen ELIMINADA (solo si no hay contenedores usándola)
```

### Comandos de control

```bash
# Ver contenedores corriendo
docker ps

# Ver todos los contenedores (incluyendo detenidos)
docker ps -a

# Detener un contenedor (como "shutdown" en Cisco, no lo borra)
docker stop mi-nginx

# Iniciar un contenedor detenido
docker start mi-nginx

# Reiniciar
docker restart mi-nginx

# Ver logs en tiempo real (como "terminal monitor" en Cisco)
docker logs -f mi-nginx

# Ejecutar un comando dentro de un contenedor que está corriendo
docker exec -it mi-nginx bash
```

---

## Ejercicio 1 — Tres contenedores de la misma imagen

```bash
# Bajá la imagen una sola vez
docker pull nginx

# Creá 3 contenedores diferentes de esa misma imagen
docker run -d --name web-1 -p 8081:80 nginx
docker run -d --name web-2 -p 8082:80 nginx
docker run -d --name web-3 -p 8083:80 nginx

# Verificá que los tres corren
docker ps
```

Esto demuestra el punto clave: **una imagen, múltiples contenedores**.

Como tener un IOS y bootar tres routers virtuales desde él.

### Limpieza

```bash
docker stop web-1 web-2 web-3
docker rm web-1 web-2 web-3
```

---

## Ejercicio 2 — Entrar a un contenedor que está corriendo

```bash
# Levantá nginx en background
docker run -d --name mi-nginx -p 8080:80 nginx

# "Entrar" al contenedor (como SSH)
docker exec -it mi-nginx bash

# Dentro del contenedor:
cat /etc/nginx/nginx.conf
ls /usr/share/nginx/html/
exit
```

`docker exec` te permite ejecutar comandos en un contenedor que ya está corriendo. No reinicia el contenedor ni lo afecta.

---

## Inspeccionar un contenedor

```bash
docker inspect mi-nginx
```

Devuelve un JSON con toda la configuración: IP asignada, puertos, volúmenes, variables de entorno, etc.

Para ver solo la IP:

```bash
docker inspect mi-nginx --format '{{.NetworkSettings.IPAddress}}'
```

---

## Resumen del módulo

```bash
docker pull nginx              # Descargar imagen sin correrla
docker images                  # Listar imágenes locales
docker run -d --name web nginx # Correr en background con nombre
docker run -p 8080:80 nginx    # Mapear puerto host:contenedor
docker stop web                # Detener
docker start web               # Iniciar detenido
docker restart web             # Reiniciar
docker logs -f web             # Logs en tiempo real
docker exec -it web bash       # Entrar al contenedor
docker rm web                  # Borrar contenedor
docker rmi nginx               # Borrar imagen
docker inspect web             # Ver toda la configuración
```

---

## Checkpoint ✓

1. Tenés la imagen de nginx descargada. ¿Cuántos contenedores podés crear a partir de ella?
2. ¿Qué diferencia hay entre `docker stop` y `docker rm`?
3. ¿Para qué sirve el flag `-p`? ¿Qué analogía de red tiene?

<details>
<summary>Ver respuestas</summary>

1. Los que quieras. La imagen es la plantilla, podés crear N contenedores.
2. `docker stop` detiene el contenedor pero lo mantiene guardado. `docker rm` lo elimina definitivamente.
3. Mapea un puerto del host a un puerto del contenedor. Analogía: NAT en Cisco — el tráfico externo al puerto X se redirige al puerto Y interno del contenedor.

</details>

---

→ [Módulo 03 — Volúmenes y Redes](../03-volumenes-redes/README.md)
