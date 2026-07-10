import 'package:flutter/material.dart';
import '../data/technique_media_data.dart';
import '../l10n/strings.dart';
import '../screens/technique_media_screen.dart';
import '../theme/judo_theme.dart';

/// Macht eine Technik-/Aufgaben-Zeile "doppelt antippbar": das erste
/// Antippen klappt (falls eine Illustration hinterlegt ist) das Bild
/// direkt unterhalb der Zeile auf, ohne den Bildschirm zu wechseln. Ein
/// zweites Antippen - oder das erste, wenn es keine Illustration gibt -
/// oeffnet wie zuvor die Medien-Detailseite mit Video-Link.
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
    if (!_expanded && image != null) {
      setState(() => _expanded = true);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TechniqueMediaScreen(technique: widget.technique),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = _expanded ? findTechniqueImage(widget.technique) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.rowBuilder(context, _handleTap, _expanded),
        if (image != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    image.url,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
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
