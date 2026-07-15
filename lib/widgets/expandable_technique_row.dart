import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/anwendungsaufgabe_description_data.dart';
import '../data/technique_media_data.dart';
import '../data/technique_video_data.dart';
import '../data/youtube_link.dart';
import '../l10n/strings.dart';
import '../theme/judo_theme.dart';

/// Macht eine Technik-/Aufgaben-Zeile "doppelt antippbar": das erste
/// Antippen klappt (falls vorhanden) eine Illustration und/oder eine kurze
/// Erklaerung direkt unterhalb der Zeile auf, ohne den Bildschirm zu
/// wechseln. Ein zweites Antippen - oder das erste, wenn es weder Bild
/// noch Erklaerung gibt - oeffnet direkt den passenden YouTube-Link (kein
/// Bildschirmwechsel).
///
/// [rowBuilder] baut die eigentliche Zeile (z.B. ein ListTile) und bekommt
/// den fertigen onTap-Handler sowie den aktuellen Aufklapp-Zustand (um z.B.
/// das Trailing-Icon anzupassen).
class ExpandableTechniqueRow extends StatefulWidget {
  final String technique;
  final Widget Function(BuildContext context, VoidCallback onTap, bool expanded)
  rowBuilder;

  const ExpandableTechniqueRow({
    super.key,
    required this.technique,
    required this.rowBuilder,
  });

  @override
  State<ExpandableTechniqueRow> createState() => _ExpandableTechniqueRowState();
}

class _ExpandableTechniqueRowState extends State<ExpandableTechniqueRow> {
  bool _expanded = false;

  void _handleTap() {
    final image = findTechniqueImage(widget.technique);
    final description = findAnwendungsaufgabeDescription(widget.technique);
    if (!_expanded && (image != null || description != null)) {
      setState(() => _expanded = true);
      return;
    }
    _openYoutube();
  }

  Future<void> _openYoutube() async {
    final curated = findTechniqueVideo(widget.technique);
    final uri = curated != null
        ? Uri.parse(curated)
        : youtubeSearchUrl(widget.technique);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.couldNotOpenLink)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _expanded ? findTechniqueImage(widget.technique) : null;
    final description = _expanded
        ? findAnwendungsaufgabeDescription(widget.technique)
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.rowBuilder(context, _handleTap, _expanded),
        if (image != null || description != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                if (image != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: image.build(),
                  ),
                  if (image.attribution != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.imageAttributionPrefix}${image.attribution}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
                if (image != null && description != null)
                  const SizedBox(height: 10),
                if (description != null)
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.tapAgainForVideoHint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: JudoColors.black.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
