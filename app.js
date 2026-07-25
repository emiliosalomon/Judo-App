import { ventilationRecommendation } from "./logic.js";

const roomsContainer = document.getElementById("rooms");
const outdoorTemp = document.getElementById("outdoor-temp");
const outdoorHumidity = document.getElementById("outdoor-humidity");
const addRoomBtn = document.getElementById("add-room");

let rooms = [
  { name: "Keller", temp: 20.4, humidity: 67.2 },
  { name: "Wohnzimmer", temp: 22.8, humidity: 41.6 },
];

function render() {
  roomsContainer.innerHTML = "";
  rooms.forEach((room, index) => {
    roomsContainer.appendChild(renderRoomCard(room, index));
  });
  updateResults();
}

function renderRoomCard(room, index) {
  const card = document.createElement("div");
  card.className = "card";
  card.innerHTML = `
    <h2>
      <input type="text" class="room-name" value="${room.name}" />
      <button class="remove" title="Standort entfernen">✕</button>
    </h2>
    <div class="field-row">
      <div class="field">
        <label>Temperatur (°C)</label>
        <input type="number" step="0.1" class="room-temp" value="${room.temp}" />
      </div>
      <div class="field">
        <label>Luftfeuchtigkeit (%)</label>
        <input type="number" step="0.1" class="room-humidity" value="${room.humidity}" />
      </div>
    </div>
    <div class="result" data-result></div>
  `;

  card.querySelector(".room-name").addEventListener("input", (e) => {
    rooms[index].name = e.target.value;
  });
  card.querySelector(".room-temp").addEventListener("input", (e) => {
    rooms[index].temp = parseFloat(e.target.value);
    updateResults();
  });
  card.querySelector(".room-humidity").addEventListener("input", (e) => {
    rooms[index].humidity = parseFloat(e.target.value);
    updateResults();
  });
  card.querySelector(".remove").addEventListener("click", () => {
    rooms.splice(index, 1);
    render();
  });

  return card;
}

function updateResults() {
  const cards = roomsContainer.querySelectorAll(".card");
  const oTemp = parseFloat(outdoorTemp.value);
  const oHumidity = parseFloat(outdoorHumidity.value);

  rooms.forEach((room, index) => {
    const resultEl = cards[index].querySelector("[data-result]");
    if (
      Number.isNaN(room.temp) ||
      Number.isNaN(room.humidity) ||
      Number.isNaN(oTemp) ||
      Number.isNaN(oHumidity)
    ) {
      resultEl.className = "result no-recommend";
      resultEl.textContent = "Bitte alle Werte ausfüllen.";
      return;
    }

    const { recommend, reason, note } = ventilationRecommendation({
      indoorTemp: room.temp,
      indoorHumidity: room.humidity,
      outdoorTemp: oTemp,
      outdoorHumidity: oHumidity,
    });

    resultEl.className = `result ${recommend ? "recommend" : "no-recommend"}`;
    resultEl.innerHTML = `
      ${recommend ? "✅ Lüften empfohlen" : "🚫 Nicht lüften"}
      <div class="detail">${reason}${note ? `<br>${note}` : ""}</div>
    `;
  });
}

outdoorTemp.addEventListener("input", updateResults);
outdoorHumidity.addEventListener("input", updateResults);

addRoomBtn.addEventListener("click", () => {
  rooms.push({ name: "Neuer Standort", temp: 21, humidity: 50 });
  render();
});

render();
