# Minecraft Szerver

Játékszerver.

## Személyre szabás
1. **Verzió**: Az `environment` szekcióban a `VERSION` változóval válthatsz Minecraft verziót.
2. **Memória**: A `deploy.resources.limits.memory` résznél állítsd be, mennyi RAM-ot kapjon a szerver.
3. **Mód**: Az `ONLINE_MODE=FALSE` lehetővé teszi a "tört" kliensek csatlakozását is.

## Használat
```bash
docker compose up -d
```
