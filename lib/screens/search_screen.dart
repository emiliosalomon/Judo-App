import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../data/kyu_grades_data.dart';
import '../data/qa_index.dart';
import '../data/qa_search.dart';
import '../data/rules_data.dart';
import '../data/search_index.dart';
import '../data/search_normalize.dart';
import '../l10n/strings.dart';
import '../models/category.dart';
import '../models/kata_info.dart';
import '../models/qa_entry.dart';
import '../models/search_entry.dart';
import '../theme/judo_theme.dart';
import 'dan_grade_detail_screen.dart';
import 'kata_detail_screen.dart';
import 'kata_screen.dart';
import 'kyu_grade_detail_screen.dart';
import 'rules_topic_detail_screen.dart';
import 'techniques_az_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Set<String> _selectedCategoryIds = {};
  final _aiController = TextEditingController();
  List<QaMatch> _aiMatches = const [];

  // Anzahl Vorschlaege, die schon vor jeder Texteingabe angezeigt werden
  // (sobald das Suchfeld fokussiert wird), damit Nutzer nicht erst tippen
  // muessen, um zu sehen, was suchbar ist.
  static const _suggestionLimit = 8;

  @override
  void dispose() {
    _aiController.dispose();
    super.dispose();
  }

  void _onAiQueryChanged(String query) {
    setState(() {
      _aiMatches = searchQa(query, judoQaIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.searchTitle)),
      body: ListView(
        key: const ValueKey('searchScreenList'),
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            AppStrings.aiSearchSectionTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const ValueKey('aiSearchField'),
            controller: _aiController,
            onChanged: _onAiQueryChanged,
            decoration: const InputDecoration(
              hintText: AppStrings.aiSearchHint,
              prefixIcon: Icon(Icons.chat_bubble_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          _AiSearchResults(query: _aiController.text, matches: _aiMatches),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            AppStrings.quickJumpLabel,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Autocomplete<SearchEntry>(
            displayStringForOption: (entry) => entry.title,
            optionsBuilder: (textEditingValue) {
              final matchesCategory = judoSearchIndex.where(
                (entry) =>
                    _selectedCategoryIds.isEmpty ||
                    _selectedCategoryIds.contains(entry.categoryId),
              );
              final query = normalizeForSearch(textEditingValue.text);
              if (query.isEmpty) {
                return matchesCategory.take(_suggestionLimit);
              }
              return matchesCategory.where(
                (entry) =>
                    normalizeForSearch(entry.title).contains(query) ||
                    normalizeForSearch(entry.contextLabel).contains(query),
              );
            },
            onSelected: (entry) => _openEntry(context, entry),
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextField(
                key: const ValueKey('quickJumpField'),
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: AppStrings.searchHint,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              final list = options.toList();
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    height: (list.length * 56).clamp(0, 280).toDouble(),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final entry = list[index];
                        return ListTile(
                          title: Text(entry.title),
                          subtitle: Text(entry.contextLabel),
                          onTap: () => onSelected(entry),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.categoriesLabel,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in judoCategories)
                FilterChip(
                  label: Text(category.titleDe),
                  selected: _selectedCategoryIds.contains(category.id),
                  onSelected: (selected) {
                    setState(() {
                      selected
                          ? _selectedCategoryIds.add(category.id)
                          : _selectedCategoryIds.remove(category.id);
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              AppStrings.searchEmptyState,
              style: TextStyle(color: JudoColors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _openEntry(BuildContext context, SearchEntry entry) {
    final Widget screen = switch (entry.targetType) {
      SearchTargetType.kyuGrade => KyuGradeDetailScreen(
        grade: judoKyuGrades.firstWhere((g) => g.kyu == entry.gradeNumber),
      ),
      SearchTargetType.danGrade => DanGradeDetailScreen(
        grade: judoDanGrades.firstWhere((g) => g.dan == entry.gradeNumber),
      ),
      SearchTargetType.techniqueCatalog => const TechniquesAZScreen(),
      SearchTargetType.kata => const KataScreen(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

/// Zeigt die Treffer der KI-Frage-Antwort-Suche direkt auf der Suchseite an
/// - keine Weiterleitung noetig, um die Antwort zu lesen.
class _AiSearchResults extends StatelessWidget {
  final String query;
  final List<QaMatch> matches;

  const _AiSearchResults({required this.query, required this.matches});

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Text(
        AppStrings.aiSearchEmptyState,
        style: TextStyle(color: JudoColors.black),
      );
    }
    if (matches.isEmpty) {
      return const Text(
        AppStrings.aiSearchNoMatch,
        style: TextStyle(color: JudoColors.black),
      );
    }
    return Column(
      children: [
        for (final match in matches) _AiSearchResultCard(entry: match.entry),
      ],
    );
  }
}

class _AiSearchResultCard extends StatelessWidget {
  final QaEntry entry;

  const _AiSearchResultCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final target = _resolveTarget(entry);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: JudoColors.red,
              ),
            ),
            const SizedBox(height: 6),
            Text(entry.answer),
            const SizedBox(height: 8),
            Text(
              '${AppStrings.aiSearchSourcePrefix}${entry.source}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (target != null) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => target)),
                  child: const Text(AppStrings.aiSearchOpenSource),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget? _resolveTarget(QaEntry entry) {
    switch (entry.targetType) {
      case QaTargetType.kyuGrade:
        final grade = judoKyuGrades.firstWhere((g) => g.kyu == entry.kyuNumber);
        return KyuGradeDetailScreen(grade: grade);
      case QaTargetType.rulesTopic:
        final topic = judoRulesTopics.firstWhere(
          (t) => t.id == entry.rulesTopicId,
        );
        return RulesTopicDetailScreen(topic: topic);
      case QaTargetType.kata:
        final info = judoKataInfos[entry.kataName];
        if (info == null) return null;
        final requiredForGrade = judoDanGrades
            .firstWhere((g) => g.kata == entry.kataName)
            .title;
        return KataDetailScreen(info: info, requiredForGrade: requiredForGrade);
      case QaTargetType.none:
        return null;
    }
  }
}
