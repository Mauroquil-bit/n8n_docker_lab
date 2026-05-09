.DEFAULT_GOAL := help
COMPOSE_FILE  := modulos/05-n8n-compose/docker-compose.yml
ENV_FILE      := modulos/05-n8n-compose/.env

## — n8n (docker-compose) ————————————————————————————

n8n-start: ## Levantar n8n + PostgreSQL en background
	@cd modulos/05-n8n-compose && docker compose up -d
	@echo "n8n disponible en http://localhost:5678"

n8n-stop: ## Detener n8n (mantiene los datos)
	@cd modulos/05-n8n-compose && docker compose down

n8n-logs: ## Ver logs en tiempo real (Ctrl+C para salir)
	@cd modulos/05-n8n-compose && docker compose logs -f

n8n-status: ## Ver estado de los servicios
	@cd modulos/05-n8n-compose && docker compose ps

n8n-restart: ## Reiniciar solo n8n (sin tocar postgres)
	@cd modulos/05-n8n-compose && docker compose restart n8n

n8n-clean: ## Borrar contenedores Y volúmenes (reset total)
	@cd modulos/05-n8n-compose && docker compose down -v
	@echo "Reset completo. Los datos fueron eliminados."

n8n-simple: ## Levantar n8n simple (SQLite, sin compose)
	docker run -d --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n n8nio/n8n
	@echo "n8n simple en http://localhost:5678"

## — Docker utilidades ————————————————————————————————

ps: ## Ver todos los contenedores corriendo
	docker ps

ps-all: ## Ver todos los contenedores (incluye detenidos)
	docker ps -a

images: ## Ver imágenes descargadas
	docker images

clean-containers: ## Borrar todos los contenedores detenidos
	docker container prune -f

clean-all: ## Borrar contenedores detenidos, imágenes sin uso y volúmenes huérfanos
	docker system prune -f

## — Ayuda ————————————————————————————————————————————

help: ## Mostrar esta ayuda
	@echo ""
	@echo "Comandos disponibles:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

.PHONY: n8n-start n8n-stop n8n-logs n8n-status n8n-restart n8n-clean n8n-simple \
        ps ps-all images clean-containers clean-all help
