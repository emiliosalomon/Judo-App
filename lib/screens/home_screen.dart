import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/category.dart';
import '../services/streak_scope.dart';
import '../theme/judo_theme.dart';
import '../widgets/category_wheel.dart';
import '../widgets/stats_banner.dart';
import 'belt_exam_screen.dart';
import 'category_placeholder_screen.dart';
import 'kata_screen.dart';
import 'leaderboard_screen.dart';
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
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            tooltip: AppStrings.leaderboardTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            ),
          ),
        ],
      ),
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
              // Grosszuegiger Abstand: das Rad zeichnet Kanji-Beschriftungen
              // per Clip.none bewusst etwas ueber seine eigene Kreisflaeche
              // hinaus - der Puffer verhindert, dass diese mit der
              // Suchleiste darunter kollidieren.
              const SizedBox(height: 56),
              const _HomeSearchBar(),
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
      _ => CategoryPlaceholderScreen(category: category),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

/// Sucheinstieg unten am Bildschirm (statt als Rad-Kategorie): sieht aus
/// wie ein Suchfeld, oeffnet aber die eigentliche Suche mit Autovervollstaendigung.
class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JudoColors.black.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              const Icon(Icons.search, color: JudoColors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.searchHint,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
