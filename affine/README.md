# AFFiNE

Tudásbázis és kollaborációs platform.

## Személyre szabás
1. **Domain**: Állítsd be a saját címedet a Traefik `rule=Host(...)` résznél.
2. **Környezet**: A szolgáltatás a szülőkönyvtárban lévő `stack.env` fájlt használja, de átírhatod helyi `.env` használatára is.
3. **Kötetek**: Állítsd be az `UPLOAD_LOCATION` és `CONFIG_LOCATION` változókat.

## Használat
```bash
docker compose up -d
```
