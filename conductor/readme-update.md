# README Frissítési Terv (Homelab)

## Cél
A jelenlegi `README.md` fájl frissítése, hogy a gyökérkönyvtárban található összes szolgáltatás (mappa) szerepeljen benne, megtartva a kategóriák szerinti strukturálást, anélkül, hogy a tényleges mappaszerkezetet megváltoztatnánk.

## Érintett fájlok
- `README.md`

## Végrehajtási lépések
1. **Hiányzó mappák azonosítása:**
   - Hozzáadandó szolgáltatások: `backup`, `cleanuparr`, `crafty`, `docker-monitor`, `forgejo`, `maintainarr`, `moodle`, `prometheus`, `repocket`, `soulsync`, `tdarr`, `tugtainer`.
2. **Kategóriák bővítése a `README.md`-ben:**
   - **Core Infrastructure & Security:** Bővítés a következőkkel: `prometheus`, `docker-monitor`, `tugtainer` (konténer értesítések), `backup`.
   - **Media & Entertainment:** Bővítés a következőkkel: `tdarr` (transcoding), `cleanuparr` / `maintainarr` (Servarr karbantartók), `crafty` (Minecraft szerver kezelő - az `mc-server` mellé), `soulsync` (zene szinkronizáció).
   - **AI & Productivity:** Kategória átnevezése **"AI, Productivity & Education"**-re (vagy fejlesztés bevonása), hozzáadva: `forgejo` (git szerver), `moodle` (LMS).
   - **Network & Utilities:** Bővítés a következőkkel: `repocket`.
3. **Végső áttekintés:**
   - Ellenőrzés, hogy az összes főkönyvtárban lévő mappa bekerült-e a dokumentációba, és minden leírás rövid és egyértelmű-e.

## Ellenőrzés
A frissítés után vizuálisan ellenőrizzük a generált Markdown fájlt, hogy megfelelő-e a formázása és teljes-e a lista.