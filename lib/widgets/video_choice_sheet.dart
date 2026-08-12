import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/technique_video_data.dart';
import '../data/youtube_link.dart';
import '../l10n/strings.dart';

/// Fragt per Auswahlmenue, ob das YouTube-Standbild (Video auf dem
/// entsprechenden Frame pausiert) oder das ganze Video geoeffnet werden
/// soll - einheitlich an jeder Stelle der App, an der eine Technik
/// antippbar ist (Guertelpruefung, Techniken-Katalog, Kata,
/// Standardsituationen, Quiz). Gibt es kein Standbild (kein kuratiertes
/// Video hinterlegt), entfaellt die Auswahl und der Tap oeffnet direkt
/// [noCuratedMatchFallback] (Standard: eine allgemeine YouTube-Suche).
///
/// Bewusst (vorerst) nicht ans Pro-Feature-Flag gekoppelt (siehe
/// app_edition.dart) - das Standbild soll allen zum Lernen zur Verfuegung
/// stehen, bis die Bildrechte mit dem Kodokan geklaert sind und eine
/// echte Free/Pro-Unterscheidung ansteht.
Future<void> chooseTechniqueVideo(
  BuildContext context,
  String technique, {
  Uri Function(String technique)? noCuratedMatchFallback,
}) async {
  final curated = findTechniqueVideo(technique);
  final thumbnail = curated != null
      ? findTechniqueVideoThumbnail(technique)
      : null;

  if (curated == null || thumbnail == null) {
    final fallback = noCuratedMatchFallback ?? youtubeSearchUrl;
    await _launch(
      context,
      curated != null ? Uri.parse(curated) : fallback(technique),
    );
    return;
  }

  final choice = await showModalBottomSheet<_VideoChoice>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _VideoChoiceSheet(),
  );
  if (choice == null) return;
  final uri = choice == _VideoChoice.standbild
      ? Uri.parse(thumbnail)
      : Uri.parse(curated);
  if (!context.mounted) return;
  await _launch(context, uri);
}

Future<void> _launch(BuildContext context, Uri uri) async {
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AppStrings.couldNotOpenLink)));
  }
}

enum _VideoChoice { standbild, full }

class _VideoChoiceSheet extends StatelessWidget {
  const _VideoChoiceSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.pause_circle_outline),
            title: const Text(AppStrings.videoChoiceStandbildOption),
            onTap: () => Navigator.of(context).pop(_VideoChoice.standbild),
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text(AppStrings.videoChoiceFullOption),
            onTap: () => Navigator.of(context).pop(_VideoChoice.full),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
