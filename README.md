# Judo-App

## Kodokan-Techniken – Screenshot-Feature (Datengrundlage)

`data/gokyo-techniques.json` enthält die 40 Wurftechniken des Kodokan **Gokyo no Waza**
(Dai Ikkyo–Dai Gokyo, je 8 Techniken) als Datengrundlage für eine spätere Anzeige-Funktion.
Jeder Eintrag hat:

- `id`, `group`, `groupOrder` – Sortierung/Gruppierung wie im Kodokan-Lehrplan
- `nameRomaji`, `nameEn`, `nameDe`, `category` (te-waza / koshi-waza / ashi-waza / ma-sutemi-waza / yoko-sutemi-waza)
- `video.url` / `video.timestampSeconds` / `video.verified` – Referenzvideo und Zeitstempel
  des Moments, in dem die Technik am besten sichtbar ist
- `screenshot.fileName` / `screenshot.status` – Dateiname und Status des zugehörigen Screenshots

### Offener Punkt: Video-Recherche

Die Technik-Namen und die Gruppenzuordnung sind geprüft. Die `video.url`- und
`timestampSeconds`-Felder sind bewusst noch mit `null` befüllt: In der Session, in der diese
Datei erstellt wurde, war der Abruf von Webseiteninhalten (WebFetch) organisationsweit
blockiert, sodass keine YouTube-Videobeschreibungen/Kapitelmarken ausgelesen werden konnten.
Erfundene Zeitstempel wären falsch und irreführend, deshalb wurden sie nicht geraten.

Als Ausgangspunkt für die Recherche eignen sich (siehe auch `meta.suggestedSources` in der JSON-Datei):

- [Kodokan × IJF Academy – „100 Techniques"](https://www.youtube.com/playlist?list=PLtz539PTepc16H2iu5F3Q3D7_He1EYlIQ) – offizielle Playlist mit einem Video je Technik
- [Gokyo-no-Waza – Right Handed Version](https://www.youtube.com/watch?v=eSZZ86v06hE) – Kompilation aller 40 Techniken in den 5 Achtergruppen
- [Kodokan Throwing Techniques (Nagewaza)](https://www.youtube.com/watch?v=RTPxyhdy4qs) – alle Techniken dynamisch demonstriert

### Screenshots in Google Drive

Geplanter Ablageort: **Google Drive → Judo → Screenshots Judo App**, ein Bild pro Technik
mit Dateiname gemäß `screenshot.fileName` (z.B. `08-seoi-nage.jpg`). Der Upload selbst ist
noch nicht automatisiert (kein Video-Frame-Extraktion in dieser Umgebung) und muss aktuell
manuell erfolgen, bis Zeitstempel verifiziert und Screenshots erstellt sind.