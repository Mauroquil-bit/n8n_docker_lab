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

> 🎯 **Concepto crítico que vas a usar todo el tiempo:**
> - **Imagen** = la plantilla. Tiene un nombre como `hello-world`, `alpine`, `ubuntu`, `nginx`.
> - **Contenedor** = la instancia corriendo de esa plantilla. Tiene un nombre **distinto**, generalmente aleatorio (`flamboyant_pasteur`, `happy_turing`), a menos que se lo pongas vos.
>
> **Una imagen puede tener muchos contenedores corriendo al mismo tiempo, igual que muchos routers idénticos pueden bootear el mismo IOS.**

---

## Resumen del módulo

```bash
docker --version                # Ver la versión instalada
docker run hello-world          # Correr un contenedor simple
docker run -it alpine sh        # Entrar interactivamente a un contenedor
docker run --rm -it alpine sh   # Lo mismo pero se autodestruye al salir
docker ps                       # Ver contenedores en ejecución
docker ps -a                    # Ver todos (incluyendo detenidos)
docker images                   # Ver imágenes descargadas
docker logs <nombre_contenedor> # Ver logs de un contenedor (¡no el de la imagen!)
docker stop <nombre_contenedor> # Detener un contenedor
docker rm <nombre_contenedor>   # Borrar un contenedor detenido
docker image rm <nombre_imagen> # Borrar una imagen
docker container prune          # Borrar todos los contenedores detenidos
```

---


## Verificar que Docker está instalado

```bash
docker --version
```

Respuesta esperada (la versión puede variar):
```
Docker version XX.X.X, build xxxxxxx
```

> 💡 Cualquier versión reciente de Docker (24 o superior) funciona para este lab. El comando y el comportamiento son iguales.

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
4f55086f7dd0: Pull complete 
d5e71e642bf5: Download complete 
Digest: sha256:f9078146db2e05e794366b1bfe584a14ea6317f44027d10ef7dad65279026885
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

> 💡 El output exacto puede variar un poco según tu versión de Docker (los hashes, los IDs de las capas), pero la estructura es siempre la misma. Lo importante es que aparezca `Hello from Docker!` y que no veas un error.

---

## ¿Qué acaba de pasar?

Cuando ejecutaste `docker run hello-world`, pasaron varias cosas. Las desglosamos en bloques.

### Primero: Docker buscó y descargó la imagen

```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pull complete 
d5e71e642bf5: Download complete 
Digest: sha256:f9078146...
Status: Downloaded newer image for hello-world:latest
```

Traducción línea por línea:

- **`Unable to find image 'hello-world:latest' locally`** → Docker buscó la imagen en tu máquina. No la encontró.
- **`Pulling from library/hello-world`** → La está descargando de Docker Hub (el repositorio público de imágenes, como un servidor TFTP en la nube).
- **`4f55086f7dd0: Pull complete`** → Son las "capas" (layers) de la imagen. Cada imagen se compone de varias capas apiladas. Lo vemos en detalle más adelante.
- **`Digest: sha256:...`** → Es el "hash" único de esa imagen. Garantiza que descargaste exactamente la imagen oficial y no una modificada (como un checksum de un IOS).
- **`Status: Downloaded newer image`** → Descarga lista.

### Después: Docker corrió el contenedor

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

Esto lo imprime el propio contenedor. Si ves este mensaje, tu instalación funciona. 🎉

### Los 4 pasos que hizo Docker

El mensaje te explica qué pasó internamente:

```
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image...
 4. The Docker daemon streamed that output to the Docker client...
```

En criollo:

1. **El cliente habló con el daemon** → Cuando escribís `docker` en la terminal, eso es el *cliente*. El que hace el trabajo pesado es el *daemon* (un servicio que corre en segundo plano). Es como el CLI vs el proceso del IOS.
2. **El daemon descargó la imagen** desde Docker Hub.
3. **Creó un contenedor** a partir de esa imagen y lo ejecutó.
4. **Te devolvió el resultado** a tu terminal.

> 💡 Cliente y daemon pueden estar en máquinas distintas. Podrías controlar Docker en un servidor remoto desde tu laptop. Lo vemos más adelante.

---

## Ejercicio 1 — Corré el comando dos veces y observá la diferencia

Volvé a ejecutar el mismo comando:

```bash
docker run hello-world
```

Esta vez vas a ver **solo** el mensaje "Hello from Docker!", sin las líneas de `Pulling` ni `Pull complete`. ¿Por qué?

Porque Docker **ya tiene la imagen guardada en caché local**. No necesita descargarla otra vez.

Ahora mirá qué contenedores existen:

```bash
docker ps -a
```

Vas a ver **dos** contenedores `hello-world` con estado `Exited (0)`:

```
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     NAMES
b2c3d4e5f6a7   hello-world   "/hello"   30 seconds ago  Exited (0) 28 seconds ago  hopeful_tesla
a1b2c3d4e5f6   hello-world   "/hello"   2 minutes ago   Exited (0) 2 minutes ago   happy_turing
```

**🎯 Aha moment:** cada vez que hacés `docker run`, se crea un contenedor **nuevo**. No se reutiliza el anterior. Es como bootear un router nuevo cada vez en lugar de reiniciar el mismo.

Fijate también que los **nombres son distintos a la imagen**. La imagen se llama `hello-world` (columna `IMAGE`), pero los contenedores se llaman `hopeful_tesla` y `happy_turing` (columna `NAMES`). Docker les inventa nombres aleatorios con la fórmula *adjetivo + científico famoso*.

Y ahora mirá las imágenes:

```bash
docker images
```

```
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    d2c94e258dcb   12 months ago  13.3kB
```

**La imagen aparece una sola vez**, aunque la usaron dos contenedores. Las imágenes se cachean y se comparten.

> 💡 Resumen: muchos contenedores pueden venir de la misma imagen, igual que muchos routers idénticos bootean el mismo IOS.

---

## Comandos básicos para explorar

### Ver las imágenes descargadas

```bash
docker images
```

Analogía: es como ver los archivos `.bin` que tenés en el flash del router.

### Ver los contenedores que están corriendo

```bash
docker ps
```

Resultado: lista vacía. Los contenedores `hello-world` ya terminaron.

### Ver TODOS los contenedores (incluyendo los detenidos)

```bash
docker ps -a
```

El estado `Exited (0)` significa que terminó correctamente (código 0 = sin errores).

### Ver los logs de un contenedor

Para ver qué imprimió un contenedor durante su ejecución, usá `docker logs` seguido del **nombre del contenedor** (no de la imagen).

> ⚠️ **Atención — error muy común en principiantes:**
> 
> Si hacés esto:
> ```bash
> docker logs hello-world
> ```
> Vas a recibir el error:
> ```
> Error response from daemon: No such container: hello-world
> ```
> 
> **¿Por qué?** Porque `hello-world` es el nombre de la **IMAGEN**, no del **CONTENEDOR**. `docker logs` necesita el nombre del contenedor, que es distinto.

**Cómo hacerlo bien — paso a paso:**

**Paso 1:** Listá tus contenedores con `docker ps -a` y mirá la columna `NAMES`:

```
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     NAMES
74da97c71f93   hello-world   "/hello"   3 minutes ago   Exited (0) 3 minutes ago   flamboyant_pasteur
```

En este ejemplo, la imagen es `hello-world` pero el **contenedor se llama `flamboyant_pasteur`**.

**Paso 2:** Usá ese nombre (no el de la imagen) con `docker logs`:

```bash
docker logs flamboyant_pasteur
```

> 💡 **Tip:** también podés usar los primeros caracteres del `CONTAINER ID`. Estos dos comandos son equivalentes:
> ```bash
> docker logs flamboyant_pasteur
> docker logs 74da
> ```

---

## Ejercicio 2 — Contenedor interactivo

Probá esto:

```bash
docker run -it alpine sh
```

Ahora estás **dentro** de un contenedor Alpine Linux. Es como hacer SSH a un equipo.

```sh
# Dentro del contenedor:
hostname              # Te devuelve el ID del contenedor (no el de tu máquina)
cat /etc/os-release   # Confirma que es Alpine Linux
ls /                  # Mirá el filesystem del contenedor
exit
```

Cuando escribís `exit`, el contenedor se detiene. Pero no se borra — sigue existiendo (detenido).

**Flags que usamos:**
- `-i` → interactivo (mantiene stdin abierto)
- `-t` → terminal (te da una consola usable)
- `alpine` → la imagen a usar (Alpine Linux, solo 7MB)
- `sh` → el comando a ejecutar al iniciar

---

## Ejercicio 3 — Contenedor que se autodestruye

¿Qué pasa si no querés que el contenedor quede guardado después de usarlo?

```bash
docker run --rm -it alpine sh
```

El flag `--rm` hace que el contenedor se borre automáticamente al salir. Útil para pruebas rápidas.

Probá hacer `docker ps -a` después de salir y vas a ver que este contenedor **no quedó** en la lista.

---

## Limpieza

Con el tiempo vas a acumular contenedores detenidos. Para limpiarlos:

```bash
# Borrar un contenedor específico (usá el nombre que veas en tu docker ps -a)
docker rm flamboyant_pasteur

# Borrar TODOS los contenedores detenidos de una vez
docker container prune
```

Para borrar imágenes que ya no usás:

```bash
docker image rm hello-world
```

> 💡 Acá fijate la diferencia:
> - `docker rm` borra **contenedores** (usa el nombre del contenedor)
> - `docker image rm` borra **imágenes** (usa el nombre de la imagen)

---

## Resumen del módulo

```bash
docker --version                # Ver la versión instalada
docker run hello-world          # Correr un contenedor simple
docker run -it alpine sh        # Entrar interactivamente a un contenedor
docker run --rm -it alpine sh   # Lo mismo pero se autodestruye al salir
docker ps                       # Ver contenedores en ejecución
docker ps -a                    # Ver todos (incluyendo detenidos)
docker images                   # Ver imágenes descargadas
docker logs <nombre_contenedor> # Ver logs de un contenedor (¡no el de la imagen!)
docker stop <nombre_contenedor> # Detener un contenedor
docker rm <nombre_contenedor>   # Borrar un contenedor detenido
docker image rm <nombre_imagen> # Borrar una imagen
docker container prune          # Borrar todos los contenedores detenidos
```

---

## Checkpoint ✓

Antes de seguir, verificá que podés responder:

1. ¿Cuál es la diferencia entre una imagen y un contenedor?
2. ¿Por qué `docker ps` no muestra el contenedor hello-world pero `docker ps -a` sí?
3. Si corrés `docker run hello-world` tres veces, ¿cuántas imágenes y cuántos contenedores tenés?
4. ¿Por qué falla el comando `docker logs hello-world`?
5. ¿Qué hace el flag `--rm`?

<details>
<summary>Ver respuestas</summary>

1. La imagen es la plantilla (como un IOS .bin). El contenedor es la instancia corriendo esa imagen (como el router que bootea ese IOS).
2. Porque `docker ps` solo muestra contenedores en ejecución. `hello-world` ejecutó su tarea y se detuvo.
3. **1 imagen y 3 contenedores.** La imagen se cachea y se reutiliza, pero cada `docker run` crea un contenedor nuevo.
4. Porque `hello-world` es el nombre de la **imagen**, no del contenedor. `docker logs` necesita el nombre del contenedor (algo como `flamboyant_pasteur`) o su `CONTAINER ID`.
5. Hace que el contenedor se borre automáticamente cuando termina o cuando hacés `exit`.

</details>

---

→ [Módulo 02 — Imágenes y contenedores en profundidad](../02-imagenes-contenedores/README.md)