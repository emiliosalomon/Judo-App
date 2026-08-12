import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/category.dart';
import '../services/app_edition.dart';
import '../services/auth_controller.dart';
import '../services/auth_scope.dart';
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
import 'rules_screen.dart';
import 'search_screen.dart';
import 'techniques_az_screen.dart';

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
          const _AccountButton(),
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
              if (isProEdition) ...[
                const _MyFightsButton(),
                const SizedBox(height: 10),
              ],
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
      'kata' => const KataScreen(),
      'techniques-az' => const TechniquesAZScreen(),
      'quiz' => const QuizScreen(),
      'rules' => const RulesScreen(),
      _ => CategoryPlaceholderScreen(category: category),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

/// Zeigt den Anmeldestatus und bietet Abmelden bzw. (im Gast-Modus) den
/// Wechsel zurueck zum Auswahlbildschirm an. Bleibt unsichtbar, solange
/// kein Firebase-Projekt konfiguriert ist oder die Free-Edition laeuft
/// (AuthStatus.disabled, siehe auth_controller.dart) - dann gibt es kein
/// Anmeldesystem, das man anzeigen koennte.
class _AccountButton extends StatelessWidget {
  const _AccountButton();

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    switch (auth.status) {
      case AuthStatus.disabled:
      case AuthStatus.loading:
      case AuthStatus.needsChoice:
        return const SizedBox.shrink();
      case AuthStatus.guest:
        return IconButton(
          icon: const Icon(Icons.person_outline),
          tooltip: AppStrings.authAccountTooltip,
          onPressed: () => _showGuestSheet(context, auth),
        );
      case AuthStatus.signedIn:
        return IconButton(
          icon: const Icon(Icons.account_circle),
          tooltip: AppStrings.authAccountTooltip,
          onPressed: () => _showSignedInSheet(context, auth),
        );
    }
  }

  void _showGuestSheet(BuildContext context, AuthController auth) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.login),
          title: const Text(AppStrings.authGuestRegisterHint),
          subtitle: const Text(AppStrings.authGuestBanner),
          onTap: () {
            Navigator.of(sheetContext).pop();
            auth.leaveGuestMode();
          },
        ),
      ),
    );
  }

  void _showSignedInSheet(BuildContext context, AuthController auth) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text(AppStrings.authSignedInAs),
              subtitle: Text(auth.userEmail ?? ''),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(AppStrings.authSignOut),
              onTap: () {
                Navigator.of(sheetContext).pop();
                auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
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
