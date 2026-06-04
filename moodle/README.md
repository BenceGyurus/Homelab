# Moodle

Oktatási keretrendszer.

## Személyre szabás
1. **Adatbázis**: Az `.env` fájlban állíts be egyedi jelszavakat.
2. **Port**: Ha a 8080-as port foglalt, módosítsd a `ports` szekcióban.
3. **Konfiguráció**: A `config.php` fájlt a saját domainedhez és adatbázisodhoz kell igazítani az első indítás után.

## Használat
```bash
cp .env.example .env
docker compose up -d
```
