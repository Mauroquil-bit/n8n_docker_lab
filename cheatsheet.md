# Docker Cheatsheet

Referencia rápida de comandos Docker. Para más detalle, ver los módulos del lab.

---

## Imágenes

```bash
docker images                    # Listar imágenes locales
docker pull nginx                # Descargar imagen
docker pull nginx:1.25           # Descargar versión específica
docker rmi nginx                 # Borrar imagen
docker image prune               # Borrar imágenes sin uso (dangling)
docker search nginx              # Buscar en Docker Hub
```

---

## Contenedores — Ciclo de vida

```bash
docker run nginx                          # Correr contenedor (foreground)
docker run -d nginx                       # Correr en background
docker run -d --name web nginx            # Con nombre
docker run -d -p 8080:80 nginx            # Mapear puerto host:contenedor
docker run -d -v datos:/var/data nginx    # Con volumen
docker run --rm nginx                     # Se autodestruye al terminar
docker run -it alpine sh                  # Interactivo con terminal
docker run -e VAR=valor nginx             # Con variable de entorno

docker stop web                           # Detener (no borra)
docker start web                          # Iniciar detenido
docker restart web                        # Reiniciar
docker rm web                             # Borrar detenido
docker rm -f web                          # Borrar aunque esté corriendo
```

---

## Contenedores — Información

```bash
docker ps                        # Contenedores corriendo
docker ps -a                     # Todos (incluye detenidos)
docker logs web                  # Ver logs
docker logs -f web               # Logs en tiempo real
docker logs --tail 50 web        # Últimas 50 líneas
docker inspect web               # Configuración completa (JSON)
docker stats                     # Uso de CPU/memoria en tiempo real
docker exec -it web bash         # Entrar a contenedor corriendo
docker exec web cat /etc/hosts   # Ejecutar comando sin entrar
```

---

## Volúmenes

```bash
docker volume create datos       # Crear volumen
docker volume ls                 # Listar volúmenes
docker volume inspect datos      # Ver detalles
docker volume rm datos           # Borrar volumen
docker volume prune              # Borrar volúmenes no usados

# Usar en docker run:
docker run -v datos:/ruta nginx              # Volumen Docker
docker run -v $(pwd)/local:/ruta nginx       # Bind mount (carpeta local)
docker run -v $(pwd)/local:/ruta:ro nginx    # Bind mount solo lectura
```

---

## Redes

```bash
docker network ls                          # Listar redes
docker network create mi-red              # Crear red
docker network inspect mi-red             # Ver detalles
docker network rm mi-red                  # Borrar red
docker network connect mi-red web         # Conectar contenedor
docker network disconnect mi-red web      # Desconectar

# Usar en docker run:
docker run --network mi-red nginx         # Conectar al crear
```

---

## Docker Compose

```bash
docker compose up                 # Levantar (foreground)
docker compose up -d              # Levantar en background
docker compose down               # Detener y borrar contenedores
docker compose down -v            # + borrar volúmenes
docker compose ps                 # Estado de servicios
docker compose logs               # Logs de todos
docker compose logs -f n8n        # Logs de un servicio
docker compose restart n8n        # Reiniciar un servicio
docker compose pull               # Actualizar imágenes
docker compose exec n8n bash      # Entrar a un servicio
```

---

## Limpieza general

```bash
docker container prune            # Borrar contenedores detenidos
docker image prune                # Borrar imágenes sin uso
docker volume prune               # Borrar volúmenes sin uso
docker network prune              # Borrar redes sin uso
docker system prune               # Todo lo anterior junto
docker system prune -a            # + imágenes no usadas por ningún contenedor
docker system df                  # Ver espacio usado por Docker
```

---

## Analogías Cisco → Docker (resumen)

| Cisco | Docker |
|-------|--------|
| Archivo IOS (.bin) | `docker image` |
| Router corriendo IOS | `container` |
| `boot system flash:ios.bin` | `docker run imagen` |
| `show ip int brief` | `docker ps` |
| `show log` | `docker logs` |
| `reload` | `docker restart` |
| `shutdown` (no borra) | `docker stop` |
| NAT / port-forward | `-p 8080:80` |
| VLAN / VRF | Docker network |
| NVRAM / Flash | Docker volume |
| Script de config | `docker-compose.yml` |
