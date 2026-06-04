# Immich

Fotó- és videókezelő platform.

## Személyre szabás
1. **Domain**: Módosítsd a Traefik címkéket (`rule=Host(...)`) a saját domainedre.
2. **Környezeti változók**: Ez a szolgáltatás a szülőkönyvtárban lévő `stack.env` fájlt várja, vagy hozz létre egy helyi `.env` fájlt.
3. **Tárhely**: Az `UPLOAD_LOCATION`, `THUMB_LOCATION` és `DB_DATA_LOCATION` változókkal állítsd be, hol tárolódjanak a képek és az adatbázis.

## Használat
```bash
# Állítsd be a változókat
docker compose up -d
```
