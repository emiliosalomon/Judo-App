import 'anwendungsaufgabe_description_data.dart';
import 'zusatztechnik_description_data.dart';

/// Gemeinsamer Einstiegspunkt fuer ExpandableTechniqueRow: sucht zu einem
/// Programmpunkt (Anwendungsaufgabe oder Dan-Zusatztechnik) zuerst in den
/// Anwendungsaufgaben-, dann in den Zusatztechniken-Erklaerungen.
String? findTechniqueDescription(String programmpunkt) =>
    findAnwendungsaufgabeDescription(programmpunkt) ??
    findZusatztechnikDescription(programmpunkt);
