# Módulo 01 — Hello Docker

## Antes de arrancar: la analogía que lo cambia todo

Si trabajaste con equipos Cisco, ya entendés Docker. Solo cambian los nombres.

| Mundo Cisco | Mundo Docker | Qué es |
|-------------|-------------|--------|
| Archivo IOS (.bin) | **Image** | El "firmware" o plantilla |
| Router corriendo ese IOS | **Container** | La instancia en ejecución |
| `boot system flash:ios.bin` | `docker run` | Arrancar desde la imagen |
| `show version` | `docker ps` | Ver qué está corriendo |
| `show log` | `docker logs` | Ver eventos del sistema |
| `reload` | `docker restart` | Reiniciar |
| `shutdown` (no borra el router) | `docker stop` | Detener sin destruir |

La diferencia clave: un **contenedor** no es una máquina virtual. Es un proceso aislado que comparte el kernel del sistema operativo host. Arranca en segundos, no en minutos.

---

## Tu primer contenedor

Escribí este comando en la terminal:

```bash
docker run hello-world
```

Vas a ver algo así:

```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
Digest: sha256:...
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

---

## ¿Qué acaba de pasar? (línea por línea)

```
Unable to find image 'hello-world:latest' locally
```
Docker buscó la imagen en tu máquina. No la encontró.

```
latest: Pulling from library/hello-world
```
La descargó de Docker Hub (el repositorio público de imágenes, como un servidor TFTP en la nube).

```
Hello from Docker!
```
El contenedor se ejecutó, imprimió el mensaje y **se apagó solo** porque su tarea terminó.

---

## Comandos básicos para explorar

### Ver las imágenes descargadas

```bash
docker images
```

```
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    d2c94e258dcb   12 months ago  13.3kB
```

Analogía: es como ver los archivos .bin que tenés en el flash del router.

### Ver los contenedores que están corriendo

```bash
docker ps
```

Resultado: lista vacía. El contenedor `hello-world` ya terminó.

### Ver TODOS los contenedores (incluyendo los detenidos)

```bash
docker ps -a
```

```
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     NAMES
a1b2c3d4e5f6   hello-world   "/hello"   2 minutes ago   Exited (0) 2 minutes ago   happy_turing
```

El estado `Exited (0)` significa que terminó correctamente (código 0 = sin errores).

### Ver los logs de un contenedor

```bash
docker logs happy_turing
```
(reemplazá `happy_turing` por el nombre que aparece en tu `docker ps -a`)

---

## Ejercicio 1 — Contenedor interactivo

Probá esto:

```bash
docker run -it alpine sh
```

Ahora estás **dentro** de un contenedor Alpine Linux. Es como hacer SSH a un equipo.

```sh
# Dentro del contenedor:
hostname
cat /etc/os-release
ping -c 3 8.8.8.8
exit
```

Cuando escribís `exit`, el contenedor se detiene. Pero no se borra — sigue existiendo (detenido).

**Flags que usamos:**
- `-i` → interactivo (mantiene stdin abierto)
- `-t` → terminal (te da una consola usable)
- `alpine` → la imagen a usar (Alpine Linux, solo 7MB)
- `sh` → el comando a ejecutar al iniciar

---

## Ejercicio 2 — Contenedor que se autodestruye

¿Qué pasa si no querés que el contenedor quede guardado después de usarlo?

```bash
docker run --rm -it alpine sh
```

El flag `--rm` hace que el contenedor se borre automáticamente al salir. Útil para pruebas rápidas.

---

## Limpieza

Con el tiempo vas a acumular contenedores detenidos. Para limpiarlos:

```bash
# Borrar un contenedor específico
docker rm happy_turing

# Borrar TODOS los contenedores detenidos de una vez
docker container prune
```

Para borrar imágenes que ya no usás:

```bash
docker image rm hello-world
```

---

## Resumen del módulo

```bash
docker run hello-world          # Correr un contenedor simple
docker run -it alpine sh        # Entrar interactivamente a un contenedor
docker run --rm -it alpine sh   # Lo mismo pero se autodestruye al salir
docker ps                       # Ver contenedores en ejecución
docker ps -a                    # Ver todos (incluyendo detenidos)
docker images                   # Ver imágenes descargadas
docker logs <nombre>            # Ver logs de un contenedor
docker stop <nombre>            # Detener un contenedor
docker rm <nombre>              # Borrar un contenedor detenido
docker container prune          # Borrar todos los contenedores detenidos
```

---

## Checkpoint ✓

Antes de seguir, verificá que podés responder:

1. ¿Cuál es la diferencia entre una imagen y un contenedor?
2. ¿Por qué `docker ps` no muestra el contenedor hello-world pero `docker ps -a` sí?
3. ¿Qué hace el flag `--rm`?

<details>
<summary>Ver respuestas</summary>

1. La imagen es la plantilla (como un IOS .bin). El contenedor es la instancia corriendo esa imagen (como el router que bootea ese IOS).
2. Porque `docker ps` solo muestra contenedores en ejecución. hello-world ejecutó su tarea y se detuvo.
3. Hace que el contenedor se borre automáticamente cuando termina o cuando hacés `exit`.

</details>

---

→ [Módulo 02 — Imágenes y contenedores en profundidad](../02-imagenes-contenedores/README.md)
