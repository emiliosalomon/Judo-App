import 'package:flutter/material.dart';
import '../models/category.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _query = TextEditingController();
  final Set<String> _selectedCategoryIds = {};

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchableCategories =
        judoCategories.where((c) => c.id != 'search').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Suche')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _query,
              decoration: const InputDecoration(
                hintText: 'Technik, Kata, Begriff ...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Kategorien', style: TextStyle(fontWeight: FontWeight.bold)),
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
                child: Text('Ergebnisse erscheinen hier, sobald Inhalte hinterlegt sind.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
