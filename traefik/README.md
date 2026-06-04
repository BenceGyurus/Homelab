# Traefik

Reverse proxy és terheléselosztó.

## Személyre szabás
1. **Dinamikus konfig**: A `/etc/traefik/dynamic` mappába rakhatod a fájl alapú szabályokat.
2. **Portok**: A 80 (HTTP) és 443 (HTTPS) portokat a hoston szabaddá kell tenned.
3. **Dashboard**: A 8080-as porton érhető el az irányítópult (alapértelmezés szerint insecure módban).

## Használat
```bash
docker compose up -d
```
A többi konténert a `labels` szekcióval tudod hozzáadni.
