# Bookmark (linkding)

Ez a mappa a [linkding](https://github.com/sissbruecker/linkding) könyvjelzőkezelő szolgáltatást tartalmazza.

## Mire jó?
- Saját könyvjelzők kezelése és tárolása.
- Gyors, minimalista felület.

## Használat
1. Másold le az `.env.example` fájlt `.env` néven:
   ```bash
   cp .env.example .env
   ```
2. Indítsd el a konténert:
   ```bash
   docker compose up -d
   ```

## Szolgáltatások
- **linkding**: A könyvjelzőkezelő, alapértelmezett port: 3003 (átirányítva 9090-re).
