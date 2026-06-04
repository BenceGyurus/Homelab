# Tdarr

Ez a mappa a [Tdarr](https://tdarr.io/) média-transzkódoló szolgáltatást tartalmazza.

## Mire jó?
- Videofájlok automatikus transzkódolása (pl. H.264 -> H.265) a tárhely megtakarítása érdekében.
- Médiafájlok ellenőrzése és hibajavítása.
- Elosztott feldolgozás (több Node használata).

## Használat
A Tdarr két részből áll: Server és Node.

### Belső Node (Serverrel együtt):
```bash
docker compose -f tdarrinternal.yml up -d
```

### Külső Node:
```bash
docker compose -f tdarrexternal.yml up -d
```

## Szolgáltatások
- **tdarr**: A központi szerver és webes felület (port 8265).
- **tdarr-node**: A feldolgozást végző egység.
