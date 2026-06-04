# Napelem (Solaris)

Inverter monitorozó rendszer.

## Személyre szabás
1. **Inverter adatok**: Az `.env` fájlban add meg az invertered IP címét és gyári számát.
2. **Domain**: Írd át a `napelem.yourdomain.com` címet a frontend Traefik címkéinél.
3. **Adatbázis**: A TimescaleDB tárolja az adatokat, a kötetet állítsd be a saját tárhelyedre.

## Használat
```bash
cp .env.example .env
docker compose up -d
```
