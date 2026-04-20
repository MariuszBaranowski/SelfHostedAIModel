ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: setup start stop logs status hash-pw

setup:
	@echo "🛠 Przygotowuję kontenery..."
	docker compose up -d
	@echo "⏳ Czekam na start silnika Ollama (15s)..."
	@sleep 15
	@echo "📥 Pobieram model: ${MAIN_MODEL}..."
	docker exec -it ollama ollama pull ${MAIN_MODEL}
	@echo "✅ Gotowe!"
	@echo "🔗 Panel WWW: https://${DOMAIN_WEBUI}:${PORT_WEBUI}"
	@echo "🔗 API IDE:   https://${DOMAIN_API}:${PORT_API}"
	@echo "🔒 Pamiętaj: Użyj Basic Auth w IDE (User: ${API_USER})"

# Komenda pomocnicza do generowania hasła dla Caddyfile
hash-pw:
	@read -p "Podaj hasło do zahashowania: " pw; \
	docker run --rm caddy caddy hash-password --plaintext "$$pw"

start:
	docker compose up -d

stop:
	docker compose down

logs:
	docker compose logs -f

status:
	docker exec -it ollama ollama list
