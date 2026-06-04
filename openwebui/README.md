# Open WebUI

Webes felület LLM-ekhez (Ollama, OpenAI API).

## Személyre szabás
1. **Domain**: A `docker-compose.yaml` fájlban a `traefik.http.routers.openwebui.rule` sorban írd át a domaint a sajátodra.
2. **Backend**: Az `.env` fájlban állítsd be az `OLLAMA_BASE_URL` vagy `OPENAI_API_BASE_URL` címeket.
3. **Adatok**: A `volumes` szekcióban add meg, hová mentse az alkalmazás az adatait.

## Használat
```bash
cp .env.example .env
# Szerkeszd az .env fájlt
docker compose up -d
```
