import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/category.dart';
import '../services/streak_scope.dart';
import '../widgets/category_wheel.dart';
import '../widgets/stats_banner.dart';
import 'belt_exam_screen.dart';
import 'category_placeholder_screen.dart';
import 'kata_screen.dart';
import 'search_screen.dart';
import 'standard_situations_screen.dart';
import 'techniques_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Erst nach dem ersten Frame aufrufen: recordVisitToday() ruft
    // notifyListeners() auf, was waehrend der Build-Phase selbst nicht
    // erlaubt ist.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) StreakScope.of(context).recordVisitToday();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              const StatsBanner(),
              const SizedBox(height: 12),
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
