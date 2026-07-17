import 'package:flutter/material.dart';
import '../data/rules_data.dart';
import '../l10n/strings.dart';
import 'rules_topic_detail_screen.dart';

/// Liste der Regelwerk-Themenbereiche (siehe rules_data.dart).
class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.rulesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(AppStrings.rulesIntro),
          const SizedBox(height: 12),
          for (final topic in judoRulesTopics)
            Card(
              child: ListTile(
                title: Text(topic.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RulesTopicDetailScreen(topic: topic),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
