# Paperless-ngx

Dokumentumarchiváló.

## Személyre szabás
1. **URL**: Az `environment` részben a `PAPERLESS_URL` legyen a saját címed.
2. **Domain**: Traefik `Host` szabály módosítása.
3. **Kötetek**: Állítsd be, hol tárolódjanak a szkennelt dokumentumok (`media`, `data`, `consume`).

## Használat
```bash
docker compose up -d
```
