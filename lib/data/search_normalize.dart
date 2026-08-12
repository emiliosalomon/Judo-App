/// Normalisiert Text fuers Suchen: klein geschrieben, ohne Bindestriche/
/// Leerzeichen. Damit findet man japanische Fachbegriffe auch ohne die
/// genaue Schreibweise zu kennen (z.B. "osotogari" statt "O-soto-gari").
String normalizeForSearch(String input) {
  return input
      .toLowerCase()
      .replaceAll('-', '')
      .replaceAll(' ', '')
      .replaceAll('ü', 'u')
      .replaceAll('ö', 'o')
      .replaceAll('ä', 'a');
}
