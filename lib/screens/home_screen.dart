import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/category.dart';
import '../widgets/category_wheel.dart';
import 'belt_exam_screen.dart';
import 'category_placeholder_screen.dart';
import 'kata_screen.dart';
import 'search_screen.dart';
import 'standard_situations_screen.dart';
import 'techniques_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                AppStrings.wheelHint,
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
    final Widget screen = switch (category.id) {
      'belt-exam' => const BeltExamScreen(),
      'techniques' => const TechniquesScreen(),
      'kata' => const KataScreen(),
      'standard-situations' => const StandardSituationsScreen(),
      'search' => const SearchScreen(),
      _ => CategoryPlaceholderScreen(category: category),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}
