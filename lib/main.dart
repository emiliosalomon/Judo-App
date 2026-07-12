import 'package:flutter/material.dart';
import 'l10n/strings.dart';
import 'screens/home_screen.dart';
import 'services/fight_log_controller.dart';
import 'services/fight_log_scope.dart';
import 'services/fight_log_store.dart';
import 'services/firestore_leaderboard_repository.dart';
import 'services/leaderboard_scope.dart';
import 'services/progress_controller.dart';
import 'services/progress_scope.dart';
import 'services/progress_store.dart';
import 'services/streak_controller.dart';
import 'services/streak_scope.dart';
import 'services/streak_store.dart';
import 'theme/judo_theme.dart';

// TODO(rangliste): Sobald `flutterfire configure` gelaufen ist und
// lib/firebase_options.dart existiert, hier ergaenzen:
//   import 'firebase_options.dart';
//   ...
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// Bis dahin bleibt Firebase.apps leer, FirestoreLeaderboardRepository.isAvailable
// liefert false und die Rangliste zeigt einen Hinweis statt Daten - der Rest
// der App funktioniert unveraendert.
void main() {
  runApp(const JudoApp());
}

Future<(ProgressStore, StreakStore, FightLogStore)> _loadStores() async {
  final progress = await ProgressStore.load();
  final streak = await StreakStore.load();
  final fightLog = await FightLogStore.load();
  return (progress, streak, fightLog);
}

class JudoApp extends StatelessWidget {
  const JudoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(ProgressStore, StreakStore, FightLogStore)>(
      future: _loadStores(),
      builder: (context, snapshot) {
        final stores = snapshot.data;
        if (stores == null) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        final (progressStore, streakStore, fightLogStore) = stores;
        return ProgressScope(
          controller: ProgressController(progressStore),
          child: StreakScope(
            controller: StreakController(streakStore),
            child: FightLogScope(
              controller: FightLogController(fightLogStore),
              child: LeaderboardScope(
                repository: FirestoreLeaderboardRepository(),
                child: MaterialApp(
                  title: AppStrings.appTitle,
                  debugShowCheckedModeBanner: false,
                  theme: judoTheme,
                  home: const HomeScreen(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
