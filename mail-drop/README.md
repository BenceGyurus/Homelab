# Mail-drop (és DDNS Updater)

Ez a mappa egy eldobható email szolgáltatást és egy DDNS frissítőt tartalmaz.

## Mire jó?
- **Maildrop**: Ideiglenes email címek fogadása a `maildrop.gyurus.hu` tartományon.
- **DDNS Updater**: Dinamikus DNS rekordok automatikus frissítése.

## Használat
Indítsd el a szolgáltatásokat:
```bash
docker compose up -d
```
A Maildrop a 5000-es (web) és 25-ös (SMTP) portokon fut.
A DDNS Updater a 8001-es porton érhető el.

## Szolgáltatások
- **maildrop**: Eldobható email szerver.
- **ddns-updater**: DNS frissítő.
