import 'package:flutter/material.dart';
import '../models/kyu_grade.dart';
import '../theme/judo_theme.dart';

class KyuGradeDetailScreen extends StatelessWidget {
  final KyuGrade grade;

  const KyuGradeDetailScreen({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(grade.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (grade.minAge != null)
            Text(
              'Mindestalter: ${grade.minAge} Jahre',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (grade.hinweis != null) ...[
            const SizedBox(height: 12),
            Text(grade.hinweis!, style: Theme.of(context).textTheme.bodyLarge),
          ],
          _Section(title: 'Ukemi-waza (Falltechnik)', items: grade.ukemiWaza),
          _Section(title: 'Nage-waza (Wurftechnik)', items: grade.nageWaza),
          _Section(
            title: 'Katame-waza (Bodentechnik)',
            items: grade.katameWaza,
          ),
          _Section(
            title: 'Anwendungsaufgaben (Standardsituationen)',
            items: grade.anwendungsaufgaben,
          ),
          _Section(title: 'Theorie-Themen', items: grade.theorieThemen),
          _Section(title: 'Zusatzbegriffe', items: grade.zusatzbegriffe),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: JudoColors.red,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('•  $item'),
            ),
        ],
      ),
    );
  }
}
