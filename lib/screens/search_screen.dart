import 'package:flutter/material.dart';
import '../data/kyu_grades_data.dart';
import '../data/dan_grades_data.dart';
import '../data/search_index.dart';
import '../data/search_normalize.dart';
import '../l10n/strings.dart';
import '../models/category.dart';
import '../models/search_entry.dart';
import '../theme/judo_theme.dart';
import 'dan_grade_detail_screen.dart';
import 'kata_screen.dart';
import 'kyu_grade_detail_screen.dart';
import 'techniques_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Set<String> _selectedCategoryIds = {};

  @override
  Widget build(BuildContext context) {
    final searchableCategories =
        judoCategories.where((c) => c.id != 'search').toList();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.searchTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Autocomplete<SearchEntry>(
              displayStringForOption: (entry) => entry.title,
              optionsBuilder: (textEditingValue) {
                final query = normalizeForSearch(textEditingValue.text);
                if (query.isEmpty) return const Iterable<SearchEntry>.empty();
                return judoSearchIndex.where((entry) {
                  final matchesCategory =
                      _selectedCategoryIds.isEmpty ||
                      _selectedCategoryIds.contains(entry.categoryId);
                  if (!matchesCategory) return false;
                  return normalizeForSearch(entry.title).contains(query) ||
                      normalizeForSearch(entry.contextLabel).contains(query);
                });
              },
              onSelected: (entry) => _openEntry(context, entry),
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                return TextField(
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
                for (final category in searchableCategories)
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
            const Expanded(
              child: Center(
                child: Text(
                  AppStrings.searchEmptyState,
                  style: TextStyle(color: JudoColors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
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
      SearchTargetType.techniqueCatalog => const TechniquesScreen(),
      SearchTargetType.kata => const KataScreen(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}
