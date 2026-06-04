# Torrent Stack

Komplex média-szerver megoldás.

## Személyre szabás
1. **Elérési utak**: A legfontosabb, hogy a `volumes` alatt lévő `./data` vagy `/home/user/torrent` útvonalakat szinkronizáld a saját média-könyvtáradhoz.
2. **Hálózat**: A `media-server` hálózat fix IP címeket használ a szolgáltatások közötti stabil kommunikációhoz (pl. Sonarr -> Transmission).
3. **Domainek**: Ha külső elérést szeretnél (pl. Plex/Jellyfin), állítsd be a domaint az `.env` fájlban vagy a környezeti változókban.

## Használat
```bash
cp .env.example .env
# Add meg a saját adataidat
docker compose up -d
```
