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
import 'my_fights_screen.dart';
import 'quiz_screen.dart';
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            children: [
              // Bewusst kompakt gehalten: die Serie/Sterne/Pokale-Anzeige
              // ist ein Nebenschauplatz, das Auswahlrad soll den groessten
              // Teil des Bildschirms einnehmen.
              const StatsBanner(),
              const SizedBox(height: 6),
              Text(
                AppStrings.wheelHint,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
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
              // Puffer, damit das Rad (das per Clip.none in seltenen Faellen
              // etwas ueber die eigene Kreisflaeche hinausragt) nicht mit
              // den Buttons darunter kollidiert.
              const SizedBox(height: 28),
              const _MyFightsButton(),
              const SizedBox(height: 10),
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
      'quiz' => const QuizScreen(),
      _ => CategoryPlaceholderScreen(category: category),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

/// Einstieg ins persoenliche Wettkampf-Tagebuch, oberhalb der Suchleiste.
class _MyFightsButton extends StatelessWidget {
  const _MyFightsButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MyFightsScreen())),
        style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
        icon: const Icon(Icons.military_tech_outlined),
        label: const Text(AppStrings.myFightsButtonLabel),
      ),
    );
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
