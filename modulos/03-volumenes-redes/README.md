# Módulo 03 — Volúmenes y Redes

## El problema de la volatilidad

Los contenedores son **efímeros por diseño**. Cuando los borrás, todo lo que escribieron adentro desaparece.

```bash
# Crear un archivo dentro de un contenedor
docker run --name test alpine sh -c "echo 'datos importantes' > /datos.txt"

# Borrar el contenedor
docker rm test

# Crear otro contenedor de la misma imagen
docker run --name test2 alpine cat /datos.txt
# Error: No such file or directory
```

Los datos se fueron. Para solucionar esto existen los **volúmenes**.

---

## Volúmenes: la NVRAM de Docker

En Cisco, la NVRAM guarda la `startup-config` — sobrevive a los reloads.
En Docker, los **volúmenes** son el almacenamiento persistente — sobreviven a que borres el contenedor.

```
Sin volumen:  [Contenedor] → datos en capa temporal → se borran con docker rm
Con volumen:  [Contenedor] → datos en volumen → persisten aunque borres el contenedor
```

---

## Tipos de almacenamiento persistente

### 1. Volúmenes Docker (recomendado)

Docker gestiona dónde se guardan los datos en el host.

```bash
# Crear un volumen
docker volume create mis-datos

# Usar ese volumen en un contenedor
docker run -v mis-datos:/datos alpine sh -c "echo 'hola' > /datos/archivo.txt"

# Borrar el contenedor
docker rm $(docker ps -aq)

# Crear otro contenedor y leer los datos
docker run -v mis-datos:/datos alpine cat /datos/archivo.txt
# Output: hola  ← los datos persisten!
```

### 2. Bind Mount (carpeta del host)

Mapea una carpeta de tu máquina directamente al contenedor.

```bash
# -v /ruta/en/host:/ruta/en/contenedor
docker run -v $(pwd)/datos:/datos alpine sh -c "echo 'hola' > /datos/archivo.txt"
```

Los archivos aparecen en tu carpeta `datos/` local. Útil para desarrollo.

### Comparación

| | Volumen Docker | Bind Mount |
|--|--------------|------------|
| Gestión | Docker | Vos |
| Portabilidad | Alta | Baja (depende de la ruta del host) |
| Caso de uso | Producción, bases de datos | Desarrollo, ver archivos desde el host |

---

## Comandos de volúmenes

```bash
docker volume create mis-datos      # Crear volumen
docker volume ls                    # Listar volúmenes
docker volume inspect mis-datos     # Ver detalles
docker volume rm mis-datos          # Borrar volumen
docker volume prune                 # Borrar todos los volúmenes no usados
```

---

## Ejercicio de volúmenes

```bash
# Crear un volumen para una "base de datos" simulada
docker volume create db-vol

# Escribir datos en el volumen
docker run --rm -v db-vol:/db alpine sh -c "echo 'registro 1' >> /db/registros.txt && echo 'registro 2' >> /db/registros.txt"

# Leer desde otro contenedor
docker run --rm -v db-vol:/db alpine cat /db/registros.txt

# El volumen persiste aunque no haya contenedores usándolo
docker volume ls
```

---

## Redes Docker: las VLANs del mundo contenedor

En Cisco usás VLANs o VRFs para aislar tráfico y controlar qué puede hablar con qué.
Docker tiene el mismo concepto: **redes** que aíslan y conectan contenedores.

### Redes por defecto

Cuando instalás Docker, ya tiene tres redes creadas:

```bash
docker network ls
```

```
NETWORK ID     NAME      DRIVER    SCOPE
a1b2c3d4e5f6   bridge    bridge    local
b2c3d4e5f6a7   host      host      local
c3d4e5f6a7b8   none      null      local
```

| Red | Analogía | Para qué sirve |
|-----|---------|---------------|
| `bridge` | VLAN por defecto | Contenedores en el mismo host se ven |
| `host` | Sin NAT, IP directa | El contenedor usa la IP del host |
| `none` | Interface en shutdown | Sin red (aislamiento total) |

### Redes personalizadas (las más útiles)

```bash
# Crear una red
docker network create mi-red

# Conectar contenedores a esa red
docker run -d --name servidor --network mi-red nginx
docker run -d --name cliente  --network mi-red alpine sleep 3600

# Los contenedores se pueden encontrar por NOMBRE (como DNS)
docker exec cliente ping servidor
```

Esto es clave: en una red personalizada, los contenedores se resuelven **por nombre**. No necesitás saber la IP.

---

## Ejercicio de redes: base de datos + aplicación

```bash
# Crear una red aislada
docker network create app-red

# Levantar una base de datos en esa red
docker run -d \
  --name mi-postgres \
  --network app-red \
  -e POSTGRES_PASSWORD=secreto \
  postgres:16-alpine

# Conectarse a la base desde otro contenedor usando el NOMBRE
docker run --rm -it \
  --network app-red \
  postgres:16-alpine \
  psql -h mi-postgres -U postgres

# Dentro de psql:
# \l       → listar bases de datos
# \q       → salir
```

Notá que usamos `mi-postgres` como hostname — Docker lo resuelve automáticamente.

---

## Inspeccionar redes

```bash
# Ver qué contenedores están en una red
docker network inspect app-red

# Conectar un contenedor existente a una red
docker network connect app-red mi-contenedor

# Desconectar
docker network disconnect app-red mi-contenedor
```

---

## Limpieza del módulo

```bash
docker stop mi-postgres
docker rm mi-postgres
docker network rm app-red mi-red
docker volume prune
```

---

## Resumen del módulo

```bash
# Volúmenes
docker volume create nombre         # Crear volumen
docker run -v nombre:/ruta imagen   # Usar volumen
docker volume ls                    # Listar
docker volume rm nombre             # Borrar

# Redes
docker network create nombre        # Crear red
docker run --network nombre imagen  # Conectar al crear
docker network ls                   # Listar redes
docker network inspect nombre       # Ver detalles
```

---

## Checkpoint ✓

1. ¿Qué pasa con los datos de un contenedor si hacés `docker rm`?
2. ¿Cuál es la diferencia entre un Volumen Docker y un Bind Mount?
3. ¿Por qué en una red personalizada podés usar el nombre del contenedor como hostname?

<details>
<summary>Ver respuestas</summary>

1. Se pierden. La capa de escritura del contenedor se elimina junto con él.
2. Un Volumen Docker es gestionado por Docker en una ubicación interna del sistema. Un Bind Mount mapea directamente una carpeta del host al contenedor.
3. Porque Docker incluye un DNS interno para redes personalizadas. Cada contenedor registra su nombre automáticamente, similar a un servidor DNS en una VLAN.

</details>

---

→ [Módulo 04 — n8n en un comando](../04-n8n-un-comando/README.md)
