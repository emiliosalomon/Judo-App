import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/category_wheel.dart';
import 'category_placeholder_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Judo App')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Ziehen zum Drehen, antippen zum Auswählen',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CategoryWheel(
                      categories: judoCategories,
                      onSelect: (category) => _openCategory(context, category),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCategory(BuildContext context, JudoCategory category) {
    if (category.id == 'search') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CategoryPlaceholderScreen(category: category),
        ),
      );
    }
  }
}
