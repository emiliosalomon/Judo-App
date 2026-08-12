import 'package:flutter/widgets.dart';
import 'fuzzy_technique_match.dart';

/// Zuordnung Technik-Name -> eigenes Foto ([TechniqueImage.asset], lokal
/// im Repo unter assets/images/techniques/...) - siehe CLAUDE.md zur
/// Bevorzugung eigenen Bildmaterials. Das automatische YouTube-Standbild
/// des kuratierten Technik-Videos wird nicht hier, sondern direkt im
/// Auswahlmenue angeboten (siehe chooseTechniqueVideo in
/// widgets/video_choice_sheet.dart) - so ist "Video-Standbild ansehen"
/// und "Ganzes Video ansehen" ueberall im selben Menue auswaehlbar,
/// unabhaengig davon, ob zusaetzlich ein eigenes Foto vorliegt.
class TechniqueImage {
  final String? assetPath;
  final String? networkUrl;
  final String? attribution;

  /// Eigenes, lokal im Repo liegendes Foto (assets/images/techniques/...).
  const TechniqueImage.asset(String path, {this.attribution})
    : assetPath = path,
      networkUrl = null;

  /// Extern gehostete Bildquelle (z.B. das YouTube-Standbild) -
  /// Attribution ist hier Pflicht.
  const TechniqueImage.network({required String url, required this.attribution})
    : networkUrl = url,
      assetPath = null;

  /// Baut das passende Image-Widget (asset oder Netzwerk). Laedt das Bild
  /// nicht, wenn es fehlt/nicht erreichbar ist, sondern zeigt nichts an
  /// (kein kaputtes Bild-Icon) - der Rest der aufgeklappten Zeile
  /// (Beschreibung etc.) bleibt trotzdem sichtbar.
  Widget build({BoxFit fit = BoxFit.contain}) {
    Widget onError(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) => const SizedBox.shrink();
    final path = assetPath;
    if (path != null) {
      return Image.asset(path, fit: fit, errorBuilder: onError);
    }
    return Image.network(networkUrl!, fit: fit, errorBuilder: onError);
  }
}

/// Eigene Fotos kommen hier rein, sobald sie vorliegen (assets/images/
/// techniques/...).
const techniqueImages = <String, TechniqueImage>{};

/// Diese Technik-Namen enthalten zwar einen kuerzeren, kuratierten
/// Schluessel als wortgrenzen-gueltigen Teilstring (z.B. "Ushiro-kesa-
/// gatame" enthaelt "Kesa-gatame"), bezeichnen aber eine eigenstaendige,
/// andere Technik - ein per Fuzzy-Match geerbtes Foto des kuerzeren
/// Schluessels waere hier irrefuehrend.
final _noFallbackImage = RegExp(
  r'\b(ushiro-kesa-gatame|harai-goshi-gaeshi|yoko-tomoe-nage)\b',
  caseSensitive: false,
);

/// Sucht per wortgrenzen-bewusstem Teilstring-Abgleich (siehe
/// fuzzy_technique_match.dart; Kyu-Programm-Namen haben oft Suffixe wie
/// " RL" oder "oder ..."), nicht per exaktem Schluessel.
TechniqueImage? findTechniqueImage(String technique) {
  if (_noFallbackImage.hasMatch(technique.toLowerCase())) return null;
  return findBestTechniqueMatch(technique, techniqueImages);
}
