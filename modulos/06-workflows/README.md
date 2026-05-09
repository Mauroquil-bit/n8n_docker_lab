# Módulo 06 — Workflows de Ejemplo

## ¿Cómo importar un workflow en n8n?

1. Abrí n8n en `http://localhost:5678`
2. En el menú lateral izquierdo, hacé clic en **Workflows**
3. Botón **Add workflow** → **Import from file**
4. Seleccioná el archivo `.json` que querés importar
5. Guardá y activá el workflow

---

## Workflows incluidos

### 01 — Ping Webhook (`01-ping-webhook.json`)

**Qué hace:** Recibe una petición HTTP y responde con un mensaje de bienvenida.

**Para qué sirve:** Entender cómo funciona un webhook. Es el "Hello World" de n8n.

**Cómo probarlo:**
```bash
# 1. Importá el workflow y activalo
# 2. Copiá la URL del nodo Webhook (aparece en el nodo)
# 3. Probalo con curl:
curl -X POST http://localhost:5678/webhook/ping \
  -H "Content-Type: application/json" \
  -d '{"mensaje": "hola"}'
```

Respuesta esperada:
```json
{
  "respuesta": "pong",
  "recibido": "hola",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

---

### 02 — Reporte Programado (`02-reporte-schedule.json`)

**Qué hace:** Cada minuto genera un "reporte" con la hora actual y lo guarda en los logs.

**Para qué sirve:** Entender los nodos Schedule Trigger y cómo depurar ejecuciones.

**Cómo probarlo:**
1. Importá y activá el workflow
2. Esperá 1 minuto
3. Hacé clic en el workflow → **Executions** para ver las ejecuciones

---

### 03 — Procesar datos JSON (`03-procesar-json.json`)

**Qué hace:** Recibe datos JSON por webhook, los transforma y devuelve una versión procesada.

**Para qué sirve:** Ver cómo n8n transforma datos entre nodos — el caso de uso más común.

**Cómo probarlo:**
```bash
curl -X POST http://localhost:5678/webhook/procesar \
  -H "Content-Type: application/json" \
  -d '{
    "equipos": [
      {"nombre": "router-01", "estado": "up"},
      {"nombre": "router-02", "estado": "down"},
      {"nombre": "switch-01", "estado": "up"}
    ]
  }'
```

Respuesta: solo los equipos con estado `down`.

---

## Ejercicio libre

Una vez que probaste los tres workflows, intentá:

1. Modificar el workflow de ping para que devuelva también la IP del cliente
2. Cambiar el schedule de 1 minuto a 5 minutos
3. Agregar un filtro al workflow de equipos para que acepte solo ciertos nombres

No hay respuesta correcta única — explorá la interfaz y los nodos disponibles.

---

## Próximos pasos

Ya terminaste el lab. Ahora sabés:

- Qué es Docker y cómo se relaciona imagen/contenedor
- Cómo gestionar volúmenes y redes
- Cómo correr n8n en Docker
- Cómo usar docker-compose para stacks multi-servicio
- Cómo crear y probar workflows básicos en n8n

**¿Qué sigue?**
- Explorar los más de 400 nodos disponibles en n8n
- Conectar n8n con servicios reales (Gmail, Slack, APIs REST)
- Leer sobre Docker Swarm o Kubernetes para escalar
