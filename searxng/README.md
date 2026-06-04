# SearXNG

Ez a mappa a [SearXNG](https://github.com/searxng/searxng) meta-keresőmotort tartalmazza.

## Mire jó?
- Adatvédelemre összpontosító kereső, amely több más kereső (Google, Bing, stb.) eredményeit összesíti.

## Használat
1. Másold le az `.env.example` fájlt `.env` néven:
   ```bash
   cp .env.example .env
   ```
2. Indítsd el a konténert:
   ```bash
   docker compose up -d
   ```
A konfiguráció a `./searxng-data` mappában található.

## Szolgáltatások
- **searxng**: A keresőmotor webes felülete (alapértelmezett port: 8080).
