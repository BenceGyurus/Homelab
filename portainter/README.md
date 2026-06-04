# Portainer

Konténerkezelő felület.

## Személyre szabás
1. **Domain**: Módosítsd a `traefik.http.routers.portainer.rule` értéket és a `command` részben a `--trusted-origins` paramétert.
2. **Kötetek**: A `/var/run/docker.sock` elengedhetetlen, az adatkönyvtárat (`/data`) állítsd be a saját tárhelyedre.

## Használat
```bash
docker compose up -d
```
