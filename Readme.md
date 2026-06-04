# Home Lab Infrastruktúra

Ez a tároló egy moduláris home lab környezet konfigurációit tartalmazza. A szolgáltatások Docker Compose, Kubernetes és Terraform segítségével kezelhetők.

## Általános Személyre Szabás

A szolgáltatások hordozhatóra lettek tervezve, de az elindításuk előtt néhány lépést meg kell tenned a saját környezetedhez igazítva:

1.  **Domain nevek**: A legtöbb szolgáltatás Traefik-et használ reverse proxy-ként. A `docker-compose.yml` fájlokban a `Host(`...`)` szabályokat írd át a saját domainedre.
2.  **Elérési utak (Volumes)**: A konfigurációkban szereplő kötetek (pl. `/mnt/hdd/...` vagy `./data`) a te tárhely-elrendezésedhez kell igazítani.
3.  **Környezeti változók**: Minden mappában található egy `.env.example`. Ezt másold le `.env` néven, és töltsd ki a saját adataiddal (jelszavak, API kulcsok, IP címek).

## Szolgáltatások Jegyzéke

### Alapvető Infrastruktúra
- [**adguard**](./adguard/README.md): DNS-szintű szűrés és reklámblokkolás.
- [**authentik**](./authentik/README.md): Identitáskezelés és SSO.
- [**traefik**](./traefik/README.md): Reverse proxy és SSL kezelés.
- [**portainter**](./portainter/README.md): Docker kezelő felület.
- [**watch-tower**](./watch-tower/README.md): Automatikus konténer frissítés.
- [**uptimekuma**](./uptimekuma/README.md): Elérhetőség monitorozás.
- [**prometheus**](./prometheus/README.md): Metrikák és Grafana dashboardok.
- [**docker-monitor**](./docker-monitor/README.md): Rendszererőforrás figyelés.

### Adat és Média
- [**seafile**](./seafile/README.md): Felhő alapú fájltárolás.
- [**paperless**](./paperless/README.md): Dokumentum archiváló.
- [**immich**](./immich/README.md): Fotó és videó kezelő.
- [**torrent**](./torrent/README.md): Média letöltő és lejátszó stack (Arr, Plex, Jellyfin).
- [**tdarr**](./tdarr/README.md): Videó transzkódoló.

### Fejlesztés és Produktivitás
- [**forgejo**](./forgejo/README.md): Git szerver.
- [**openwebui**](./openwebui/README.md): AI/LLM webes felület.
- [**affine**](./affine/README.md): Jegyzetelés és tudásbázis.
- [**vsc**](./vsc/README.md): Webes VS Code.

## Telepítés lépései

1. Válaszd ki a szolgáltatást.
2. Ellenőrizd a `README.md`-t a mappájában.
3. Állítsd be a `.env` fájlt.
4. Indítsd el: `docker compose up -d`.
