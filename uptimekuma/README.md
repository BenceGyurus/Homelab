# Uptime Kuma

Monitorozó szolgáltatás.

## Személyre szabás
1. **Domain**: Írd át a `traefik.http.routers.uptime.rule` értéket.
2. **Környezet**: Az `environment` részben a `URL` változót állítsd a saját publikus címedre.
3. **Tárolás**: Állítsd be a `volumes` alatt a perzisztens tárhelyet.

## Használat
```bash
docker compose up -d
```
