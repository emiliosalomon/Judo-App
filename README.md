# Judo-App – Lüftungsassistent

Kleine Web-App, die auf Basis von Innen- und Außentemperatur/-luftfeuchtigkeit
(z. B. aus Thermo-Hygrometer-Sensoren wie im Screenshot einer Smart-Home-App)
eine Empfehlung gibt, ob gerade Lüften sinnvoll ist.

## Warum absolute statt relative Luftfeuchtigkeit?

Die relative Luftfeuchtigkeit (%) allein sagt wenig darüber aus, ob Lüften
etwas bringt, da sie stark von der Temperatur abhängt. Entscheidend ist die
**absolute Luftfeuchtigkeit** (Gramm Wasserdampf pro m³ Luft): Lüften senkt
die Feuchtigkeit in der Wohnung nur, wenn die Außenluft weniger Wasserdampf
pro m³ enthält als die Innenluft. Die App berechnet die absolute
Luftfeuchtigkeit über die Magnus-Formel und vergleicht Innen- und Außenwerte.

## Nutzung

Kein Build nötig – einfach `index.html` im Browser öffnen, oder lokal
servieren, z. B.:

```
npx serve .
```

Voreingestellt sind Beispielwerte für Keller, Wohnzimmer und Außenbereich.
Werte lassen sich direkt anpassen, weitere Standorte über
"+ Standort hinzufügen" ergänzen.

Hinweis: Die App liest keine Live-Daten aus einer Smart-Home-Cloud aus –
Werte müssen (aktuell) manuell aus der jeweiligen Geräte-App übertragen
werden.

## Tests

```
node --test
```

Prüft die Berechnung der absoluten Luftfeuchtigkeit sowie die
Lüften-Empfehlung anhand fester Referenzwerte.
