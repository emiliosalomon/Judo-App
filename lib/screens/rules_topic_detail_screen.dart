import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/rules_topic.dart';
import '../theme/judo_theme.dart';

/// Zeigt alle Abschnitte eines Regelwerk-Themas (siehe rules_data.dart).
class RulesTopicDetailScreen extends StatelessWidget {
  final RulesTopic topic;

  const RulesTopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final section in topic.sections)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: JudoColors.red,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (section.text != null)
                    Text(section.text!)
                  else if (section.bullets.isEmpty)
                    Text(
                      AppStrings.rulesPendingNote,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  for (final bullet in section.bullets)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('${AppStrings.bullet}$bullet'),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
