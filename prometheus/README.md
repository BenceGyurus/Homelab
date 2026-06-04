# Monitoring Stack

Metrikák gyűjtése és vizualizációja.

## Személyre szabás
1. **Grafana Domain**: Írd át a `grafana.yourdomain.com` címet a Traefik beállításoknál.
2. **Prometheus Config**: A `prometheus.yml` fájlban add meg, mely szolgáltatásokat (target-eket) akarod figyelni (pl. node-exporter IP-je).
3. **Jelszavak**: A Grafana admin jelszavát az `.env` fájlban tudod módosítani.

## Használat
```bash
cp .env.example .env
docker compose up -d
```
