# Módulo 00 — Por qué GitHub Codespaces

## El problema de siempre

Cada vez que querés aprender una tecnología nueva, antes de escribir una sola línea necesitás:

1. Instalar el software
2. Configurar variables de entorno
3. Resolver conflictos de versiones
4. Escuchar "en mi máquina funciona"
5. Perder 2 horas antes de ver algo en pantalla

Con Docker esto se multiplica porque además necesitás instalar Docker Desktop, que ocupa ~2GB, requiere virtualización habilitada en la BIOS y en Windows puede pelear con WSL2.

**GitHub Codespaces resuelve todo esto.**

---

## ¿Qué es un Codespace?

Es una computadora virtual en la nube que GitHub te da para trabajar en tu repositorio. Viene preconfigurada con:

- Ubuntu Linux
- Git
- **Docker instalado y funcionando**
- VS Code en el navegador (sin instalar nada)
- Acceso a internet

Lo abrís desde cualquier computadora, incluso desde una tablet. Cuando terminás, lo cerrás. No ocupa espacio en tu máquina.

---

## Cómo abrir este lab en Codespaces

### Paso 1 — Ir al repositorio

Entrá a: `https://github.com/Mauroquil-bit/n8n_docker_lab`

### Paso 2 — Crear el Codespace

Hacé clic en el botón verde **`<> Code`** → pestaña **Codespaces** → **Create codespace on master**

![Botón Code en GitHub](../../assets/codespace-button.png)

### Paso 3 — Esperar que cargue

La primera vez tarda ~1 minuto. Verás VS Code abriéndose en el navegador con una terminal integrada.

### Paso 4 — Verificar Docker

En la terminal escribí:

```bash
docker --version
```

Respuesta esperada:
```
Docker version 29.0.x, build xxxxxxx
```

```bash
docker ps
```

Respuesta esperada:
```
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
```

(Lista vacía — todavía no corremos ningún contenedor, eso viene en el Módulo 01)

---

## Plan gratuito de Codespaces

GitHub ofrece **120 horas/mes gratis** en el plan personal. Para este lab alcanza y sobra.

| Acción | Cómo hacerlo |
|--------|-------------|
| Ver mis Codespaces activos | github.com/codespaces |
| Pausar un Codespace | Se pausa solo después de 30 min sin actividad |
| Borrar un Codespace | github.com/codespaces → `...` → Delete |

> **Tip:** Cuando termines de practicar, detené el Codespace para no consumir horas del plan gratuito. Tus archivos se guardan aunque lo pares.

---

## ¿Por qué Docker ya viene instalado?

Porque el Codespace corre sobre un contenedor Docker. GitHub lo configuró para que Docker funcione dentro de Docker (técnica llamada Docker-in-Docker o DinD). No necesitás entender esto ahora — solo saber que funciona.

---

## Siguiente paso

Ya tenés el entorno listo. Vamos a correr tu primer contenedor.

Continuar con el Módulo 01 → [Módulo 01 — Hello Docker](../01-hello-docker/README.md)
