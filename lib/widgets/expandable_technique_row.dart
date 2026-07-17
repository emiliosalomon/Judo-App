import 'package:flutter/material.dart';
import '../data/technique_description_lookup.dart';
import '../data/technique_media_data.dart';
import '../l10n/strings.dart';
import '../theme/judo_theme.dart';
import 'video_choice_sheet.dart';

/// Macht eine Technik-/Aufgaben-Zeile "doppelt antippbar": das erste
/// Antippen klappt (falls vorhanden) ein eigenes Foto und/oder eine kurze
/// Erklaerung direkt unterhalb der Zeile auf, ohne den Bildschirm zu
/// wechseln. Ein zweites Antippen - oder das erste, wenn es weder Foto
/// noch Erklaerung gibt - oeffnet das Video-Auswahlmenue (Standbild/
/// ganzes Video, siehe chooseTechniqueVideo).
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
    final description = findTechniqueDescription(widget.technique);
    if (!_expanded && (image != null || description != null)) {
      setState(() => _expanded = true);
      return;
    }
    chooseTechniqueVideo(context, widget.technique);
  }

  @override
  Widget build(BuildContext context) {
    final image = _expanded ? findTechniqueImage(widget.technique) : null;
    final description = _expanded
        ? findTechniqueDescription(widget.technique)
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
                  AspectRatio(
                    // Feste Seitenverhaeltnis-Vorgabe, weil Image ohne
                    // definierte Groesse innerhalb einer ListView
                    // (unbegrenzte Hoehe) sonst auf Groesse 0 kollabiert
                    // und gar nicht angezeigt wird.
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: image.build(),
                    ),
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
