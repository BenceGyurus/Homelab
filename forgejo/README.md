# Forgejo

Ön-hosztolt git szolgáltatás.

## Személyre szabás
1. **Domain**: Írd át a Traefik szabályt a saját domainedre.
2. **Adatbázis**: Az `.env` fájlban add meg az adatbázis felhasználót és jelszót.
3. **SSH Port**: Ha a 22-es port foglalt a hoston, módosítsd a külső portot a `ports` szekcióban (alapértelmezett: 222).

## Használat
```bash
cp .env.example .env
# Beállítás után:
docker compose up -d
```
