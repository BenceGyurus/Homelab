# Tugtainer

Docker konténer eseménykezelő.

## Személyre szabás
1. **Titkos kulcs**: Az `.env` fájlban állíts be egy egyedi `AGENT_SECRET`-et.
2. **Docker Socket**: A biztonság fokozása érdekében egy `socket-proxy`-n keresztül éri el a Docker API-t.

## Használat
```bash
cp .env.example .env
docker compose up -d
```
