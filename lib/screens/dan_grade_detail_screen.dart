import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../l10n/strings.dart';
import '../models/dan_grade.dart';
import '../theme/belt_colors.dart';
import '../theme/judo_theme.dart';
import '../widgets/belt_knot_icon.dart';
import 'technique_media_screen.dart';

class DanGradeDetailScreen extends StatelessWidget {
  final DanGrade grade;

  const DanGradeDetailScreen({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    final beltColors = beltColorsFromName(grade.beltDescription);
    return Scaffold(
      appBar: AppBar(title: Text(grade.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              BeltKnotIcon(colors: beltColors, size: 42),
              const SizedBox(width: 10),
              Text(
                AppStrings.beltLabel(grade.beltDescription),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (grade.kata != null) ...[
            const SizedBox(height: 12),
            const Text(
              AppStrings.requiredKataLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: JudoColors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(grade.kata!),
          ],
          if (grade.hinweis != null) ...[
            const SizedBox(height: 16),
            Text(grade.hinweis!),
          ],
          if (grade.zusatztechniken.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              AppStrings.zusatztechnikenLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: JudoColors.red,
              ),
            ),
            const SizedBox(height: 8),
            for (final technik in grade.zusatztechniken)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: BeltKnotIcon(colors: beltColors, size: 30),
                title: Text(technik),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TechniqueMediaScreen(technique: technik),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 20),
          const Text(
            AppStrings.theorieThemenbereicheLabel,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: JudoColors.red,
            ),
          ),
          const SizedBox(height: 8),
          for (final thema in danTheorieThemenbereiche)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BeltKnotIcon(colors: beltColors, size: 28),
                  const SizedBox(width: 10),
                  Expanded(child: Text(thema)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
