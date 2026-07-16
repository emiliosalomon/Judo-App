import 'package:flutter/widgets.dart';
import 'fuzzy_technique_match.dart';
import 'technique_video_data.dart';

/// Zuordnung Technik-Name -> Bild: entweder ein eigenes Foto
/// ([TechniqueImage.asset], lokal im Repo unter assets/images/techniques/,
/// bevorzugt sobald vorhanden - siehe CLAUDE.md zur Bevorzugung eigenen
/// Bildmaterials) oder, als automatischer Fallback ohne manuelle Pflege,
/// das offizielle YouTube-Vorschaubild des kuratierten Technik-Videos
/// (siehe [findTechniqueVideoThumbnail] in technique_video_data.dart).
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

const _videoStandbildAttribution = 'Standbild aus dem verlinkten YouTube-Video';

/// Eigene Fotos kommen hier rein, sobald sie vorliegen (assets/images/
/// techniques/...). Bis dahin liefert [findTechniqueImage] automatisch
/// das YouTube-Standbild des kuratierten Videos als Bild.
const techniqueImages = <String, TechniqueImage>{};

/// Diese Technik-Namen enthalten zwar einen kuerzeren, kuratierten
/// Schluessel als wortgrenzen-gueltigen Teilstring (z.B. "Ushiro-kesa-
/// gatame" enthaelt "Kesa-gatame"), bezeichnen aber eine eigenstaendige,
/// andere Technik - ein per Fuzzy-Match geerbtes Foto des kuerzeren
/// Schluessels waere hier irrefuehrend. Gilt nur fuer [techniqueImages]
/// (eigene Fotos); das YouTube-Standbild hat dieses Problem nicht, da
/// techniqueVideos fuer diese Faelle eigene, unverwechselbare Eintraege
/// hat (siehe technique_video_data_test.dart).
final _noFallbackImage = RegExp(
  r'\b(ushiro-kesa-gatame|harai-goshi-gaeshi|yoko-tomoe-nage)\b',
  caseSensitive: false,
);

/// Sucht per wortgrenzen-bewusstem Teilstring-Abgleich (siehe
/// fuzzy_technique_match.dart; Kyu-Programm-Namen haben oft Suffixe wie
/// " RL" oder "oder ..."), nicht per exaktem Schluessel. Ohne eigenes Foto
/// faellt die Suche automatisch auf das YouTube-Standbild des kuratierten
/// Videos zurueck (deckt so jede Technik mit Video-Link ab, ohne fuer
/// jede einzeln ein Bild pflegen zu muessen).
TechniqueImage? findTechniqueImage(String technique) {
  if (!_noFallbackImage.hasMatch(technique.toLowerCase())) {
    final ownPhoto = findBestTechniqueMatch(technique, techniqueImages);
    if (ownPhoto != null) return ownPhoto;
  }
  final thumbnailUrl = findTechniqueVideoThumbnail(technique);
  if (thumbnailUrl == null) return null;
  return TechniqueImage.network(
    url: thumbnailUrl,
    attribution: _videoStandbildAttribution,
  );
}
