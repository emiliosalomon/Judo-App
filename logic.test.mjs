import { test } from "node:test";
import assert from "node:assert/strict";
import { absoluteHumidity, ventilationRecommendation } from "./logic.js";

test("absoluteHumidity matches known reference values", () => {
  // 20°C, 50% rH -> ca. 8.65 g/m3 (Referenzwert Magnus-Formel)
  assert.ok(Math.abs(absoluteHumidity(20, 50) - 8.65) < 0.05);
});

test("recommends ventilating when outdoor air is drier", () => {
  const result = ventilationRecommendation({
    indoorTemp: 20.4,
    indoorHumidity: 67.2,
    outdoorTemp: 25.2,
    outdoorHumidity: 48.8,
  });
  assert.equal(result.recommend, true);
});

test("does not recommend ventilating when outdoor air is more humid", () => {
  const result = ventilationRecommendation({
    indoorTemp: 22.8,
    indoorHumidity: 41.6,
    outdoorTemp: 25.2,
    outdoorHumidity: 48.8,
  });
  assert.equal(result.recommend, false);
});

test("does not recommend when indoor and outdoor are nearly equal", () => {
  const result = ventilationRecommendation({
    indoorTemp: 20,
    indoorHumidity: 50,
    outdoorTemp: 20,
    outdoorHumidity: 50,
  });
  assert.equal(result.recommend, false);
});
