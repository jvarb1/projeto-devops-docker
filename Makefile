# Makefile para facilitar operações comuns do projeto

.PHONY: help setup build up down restart logs clean test health

help: ## Mostra esta mensagem de ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## Configura variáveis de ambiente
	@if [ -f "scripts/setup-env.sh" ]; then \
		chmod +x scripts/setup-env.sh && ./scripts/setup-env.sh; \
	elif [ -f "scripts/setup-env.ps1" ]; then \
		powershell -ExecutionPolicy Bypass -File scripts/setup-env.ps1; \
	else \
		echo "Script de setup não encontrado"; \
	fi

build: ## Constrói as imagens Docker
	docker-compose build --no-cache

up: ## Inicia os containers
	docker-compose up -d

down: ## Para os containers
	docker-compose down

restart: ## Reinicia os containers
	docker-compose restart

logs: ## Mostra logs dos containers
	docker-compose logs -f

logs-app: ## Mostra logs apenas da aplicação
	docker-compose logs -f app

logs-db: ## Mostra logs apenas do banco de dados
	docker-compose logs -f db

clean: ## Remove containers, volumes e imagens
	docker-compose down -v --rmi all

test: ## Executa testes da API
	@if [ -f "scripts/test-api.sh" ]; then \
		chmod +x scripts/test-api.sh && ./scripts/test-api.sh; \
	elif [ -f "scripts/test-api.ps1" ]; then \
		powershell -ExecutionPolicy Bypass -File scripts/test-api.ps1; \
	else \
		echo "Testando endpoint de health..."; \
		curl -s http://localhost:8000/health || echo "API não está respondendo"; \
	fi

health: ## Verifica saúde dos containers
	@echo "Verificando status dos containers..."
	@docker-compose ps
	@echo ""
	@echo "Verificando saúde da API..."
	@curl -s http://localhost:8000/health || echo "API não está respondendo"
	@echo ""

ps: ## Lista containers em execução
	docker-compose ps

exec-app: ## Executa shell no container da aplicação
	docker-compose exec app sh

exec-db: ## Executa psql no container do banco
	docker-compose exec db psql -U taskuser -d taskdb

