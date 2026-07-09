import 'package:flutter/material.dart';
import '../models/kata_info.dart';
import '../theme/judo_theme.dart';

class KataDetailScreen extends StatelessWidget {
  final KataInfo info;
  final String requiredForGrade;

  const KataDetailScreen({
    super.key,
    required this.info,
    required this.requiredForGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(info.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            info.meaning,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: JudoColors.red,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text('Pflicht-Kata für den $requiredForGrade'),
          const SizedBox(height: 16),
          Text(info.description),
          const SizedBox(height: 20),
          if (info.sectionsAreSummaryOnly)
            const Text(
              'Struktur (ausführliche Technik-Liste folgt):',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          else
            const Text(
              'Techniken',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 8),
          for (final section in info.sections)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  for (final technique in section.techniques)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 0, 0),
                      child: Text('•  $technique'),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
