import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../models/kata_info.dart';
import 'kata_detail_screen.dart';

/// Die 6 offiziell von OeJV/IJF/Kodokan anerkannten Kata, zugeordnet zu dem
/// Dan-Grad, fuer den sie laut Danordnung Pflicht-Kata sind.
class KataScreen extends StatelessWidget {
  const KataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final katas = judoDanGrades.where((grade) => grade.kata != null).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Kata')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Die formalen Kata-Uebungen, jeweils Pflicht-Kata fuer eine '
            'Dan-Pruefung laut OeJV-Danordnung.',
          ),
          const SizedBox(height: 12),
          for (final grade in katas)
            Card(
              child: ListTile(
                title: Text(grade.kata!),
                subtitle: Text('Pflicht-Kata für den ${grade.title}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  final info = judoKataInfos[grade.kata];
                  if (info == null) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => KataDetailScreen(
                        info: info,
                        requiredForGrade: grade.title,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
