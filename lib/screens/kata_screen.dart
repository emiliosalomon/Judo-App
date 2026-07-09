import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../theme/judo_theme.dart';

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
                onTap: () => _showKataInfo(context, grade.kata!, grade.title),
              ),
            ),
        ],
      ),
    );
  }

  void _showKataInfo(BuildContext context, String kata, String danTitle) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(kata),
        content: Text(
          'Pflicht-Kata für den $danTitle.\n\nSchritt-für-Schritt-Inhalte '
          'folgen — Bewertungsgrundlage sind die aktuellen EJU-/IJF-'
          'Kata-Richtlinien und die Kodokan-Textbücher.',
        ),
        backgroundColor: JudoColors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }
}
