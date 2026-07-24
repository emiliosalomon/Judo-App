import 'package:flutter/material.dart';
import '../data/technique_translations_data.dart';
import '../data/techniques_data.dart';
import '../l10n/strings.dart';
import '../theme/judo_theme.dart';
import '../widgets/expandable_technique_row.dart';

/// Alle Basistechniken (Kodokan-Gokyo + Katame-waza) alphabetisch zum
/// Nachschlagen, gegliedert in Stand- und Bodentechniken. Ersetzt die
/// fruehere "Standardsituationen"-Kategorie, deren Inhalte (Anwendungs-
/// aufgaben) bereits 1:1 bei der jeweiligen Guertelstufe zu finden waren.
class TechniquesAZScreen extends StatelessWidget {
  const TechniquesAZScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final standTechniken = [...kodokanGokyoNageWaza]..sort();
    final bodenTechniken = [...osaeKomiWaza, ...shimeWaza, ...kansetsuWaza]
      ..sort();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.techniquesAZTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(AppStrings.techniquesAZIntro),
          _TechniqueAZSection(
            title: AppStrings.standTechniquesSection,
            techniques: standTechniken,
          ),
          _TechniqueAZSection(
            title: AppStrings.groundTechniquesSection,
            techniques: bodenTechniken,
          ),
        ],
      ),
    );
  }
}

class _TechniqueAZSection extends StatelessWidget {
  final String title;
  final List<String> techniques;

  const _TechniqueAZSection({required this.title, required this.techniques});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.techniqueSectionTitle(title, techniques.length),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: JudoColors.red,
            ),
          ),
          const SizedBox(height: 8),
          for (final technique in techniques)
            ExpandableTechniqueRow(
              technique: technique,
              rowBuilder: (context, onTap, expanded) => ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(
                  technique,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: JudoColors.black,
                  ),
                ),
                subtitle: _translationSubtitle(technique),
                trailing: const Icon(Icons.play_circle_outline),
                onTap: onTap,
              ),
            ),
        ],
      ),
    );
  }
}

Widget? _translationSubtitle(String technique) {
  final translation = translateTechnique(technique);
  return translation == null ? null : Text(translation);
}
