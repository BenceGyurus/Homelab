# SoulSync

Zene-szinkronizáló szolgáltatás.

## Személyre szabás
1. **OAuth portok**: Ha a Spotify/Tidal hitelesítéshez használt portok (8888, 8889) foglaltak, módosítsd őket az `.env` fájlban.
2. **Időzóna**: Állítsd be a `TZ` változót.
3. **Kötetek**: Add meg a zenei könyvtárad és a letöltési mappa helyét.

## Használat
```bash
cp .env.example .env
docker compose up -d
```
