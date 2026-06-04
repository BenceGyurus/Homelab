# VS Code (code-server)

Böngészőben futó fejlesztői környezet.

## Személyre szabás
1. **Jelszó**: Az `.env` fájlban állítsd be a `PASSWORD` változót a belépéshez.
2. **Domain**: Írd át a `PROXY_DOMAIN` változót és a Traefik szabályt.
3. **Munkakörnyezet**: A `volumes` alatt add meg, melyik mappát szeretnéd szerkeszteni.

## Használat
```bash
cp .env.example .env
docker compose up -d
```
