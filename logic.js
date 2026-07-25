// Lüftungslogik: Vergleich der absoluten Luftfeuchtigkeit (Wasserdampf pro m³ Luft)
// zwischen Innen- und Außenluft. Nur wenn draußen weniger Wasserdampf pro m³ steckt
// als drinnen, senkt Lüften tatsächlich die Luftfeuchtigkeit in der Wohnung.

// Sättigungsdampfdruck nach Magnus-Formel (hPa), gültig für -45°C bis 60°C.
function saturationVaporPressure(tempC) {
  return 6.112 * Math.exp((17.62 * tempC) / (243.12 + tempC));
}

// Absolute Luftfeuchtigkeit in g/m³.
export function absoluteHumidity(tempC, relHumidityPercent) {
  const svp = saturationVaporPressure(tempC);
  return (216.7 * (relHumidityPercent / 100) * svp) / (273.15 + tempC);
}

const MARGIN_G_PER_M3 = 0.5;

export function ventilationRecommendation({ indoorTemp, indoorHumidity, outdoorTemp, outdoorHumidity }) {
  const indoorAH = absoluteHumidity(indoorTemp, indoorHumidity);
  const outdoorAH = absoluteHumidity(outdoorTemp, outdoorHumidity);
  const diff = indoorAH - outdoorAH;

  let recommend;
  let reason;

  if (diff > MARGIN_G_PER_M3) {
    recommend = true;
    reason = `Außenluft enthält ${diff.toFixed(1)} g/m³ weniger Wasserdampf als die Innenluft – Lüften senkt die Luftfeuchtigkeit.`;
  } else if (diff < -MARGIN_G_PER_M3) {
    recommend = false;
    reason = `Außenluft enthält ${Math.abs(diff).toFixed(1)} g/m³ mehr Wasserdampf als die Innenluft – Lüften würde die Luftfeuchtigkeit erhöhen.`;
  } else {
    recommend = false;
    reason = "Innen- und Außenluft enthalten etwa gleich viel Wasserdampf – Lüften bringt aktuell kaum einen Effekt.";
  }

  let note = null;
  if (recommend && outdoorTemp <= 0) {
    note = "Es ist sehr kalt draußen: nur kurz stoßlüften (5–10 Minuten), um Wärmeverlust zu begrenzen.";
  } else if (recommend) {
    note = "Am effektivsten: Fenster 5–15 Minuten weit öffnen (Stoßlüften) statt dauerhaft kippen.";
  }

  return { indoorAH, outdoorAH, diff, recommend, reason, note };
}
