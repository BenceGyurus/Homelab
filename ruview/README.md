# Ruview (WiFi DensePose)

Ez a mappa a [WiFi DensePose](https://github.com/Ruview/WiFi-DensePose) projektet tartalmazza.

## Mire jó?
- Emberi alakok detektálása és póz-becslése WiFi jelek (CSI) alapján.

## Használat
Indítsd el a konténert:
```bash
docker compose up -d
```
A szerver a 3000-es (web), 5005-ös (UDP) és 3001-es portokon várja a kapcsolatokat.

## Szolgáltatások
- **wifi-densepose**: A jelfeldolgozó és megjelenítő szerver.
