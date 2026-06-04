# Seafile

Fájlszinkronizáló szolgáltatás.

## Személyre szabás
1. **Hostname**: Az `.env` fájlban a `SEAFILE_SERVER_HOSTNAME` értéke legyen a saját domained.
2. **Traefik**: A `seafile-server.yml`-ben írd át a `Host(`...`)` szabályokat.
3. **Adatbázis**: Állíts be egyedi, erős jelszavakat az `.env` fájlban.
4. **Kötetek**: A `shared` mappák helyét igazítsd a saját rendszeredhez.

## Használat
```bash
cp .env.example .env
# Szerkesztés után:
docker compose -f seafile-server.yml up -d
```
