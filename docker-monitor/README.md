# Docker Monitor

Rendszererőforrás monitorozás.

## Személyre szabás
1. **Portok**: A cAdvisor a 8082-es, a Node Exporter a 9101-es porton fut alapértelmezés szerint.
2. **Jogosultságok**: A cAdvisor-nak `privileged` módra van szüksége a gazdagép statisztikáinak eléréséhez.

## Használat
```bash
docker compose up -d
```
A metrikák a `/metrics` végponton érhetők el a Prometheus számára.
