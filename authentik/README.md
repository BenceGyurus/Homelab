# Authentik

Identitáskezelő és SSO.

## Személyre szabás
1. **Domain**: Állítsd be az `auth.yourdomain.com` címet a Traefik címkéknél.
2. **Email**: Az email küldéshez szükséges adatokat (SMTP host, user, pass) az `.env` vagy `stack.env` fájlban kell megadnod.
3. **Titkos kulcs**: Generálj egy egyedi `AUTHENTIK_SECRET_KEY`-t.

## Használat
```bash
docker compose up -d
```
