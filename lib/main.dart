import 'package:flutter/material.dart';
import 'l10n/strings.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_auth_screen.dart';
import 'services/auth_controller.dart';
import 'services/auth_scope.dart';
import 'services/auth_service.dart';
import 'services/cloud_sync.dart';
import 'services/fight_log_controller.dart';
import 'services/fight_log_scope.dart';
import 'services/fight_log_store.dart';
import 'services/firestore_leaderboard_repository.dart';
import 'services/guest_choice_store.dart';
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
// Bis dahin bleibt Firebase.apps leer, AuthController.status ist immer
// AuthStatus.disabled (Anmelde-Auswahlbildschirm wird uebersprungen) und
// FirestoreLeaderboardRepository.isAvailable liefert false - der Rest der
// App funktioniert unveraendert wie vor dem Anmeldesystem.
void main() {
  runApp(const JudoApp());
}

const _loadingApp = MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Scaffold(body: Center(child: CircularProgressIndicator())),
);

/// Wurzel der App. Wichtig: es gibt genau eine [MaterialApp] (also einen
/// Navigator) fuer die gesamte Lebensdauer der App - Anmelde-Auswahl,
/// Login/Registrierung und die eigentliche App sind Routen/Zustaende
/// *innerhalb* dieser einen MaterialApp, nicht mehrere verschachtelte Apps.
/// Nur so sehen auch spaeter gepushte Screens (z.B. BeltExamScreen) die
/// Scopes (ProgressScope etc.), die um die MaterialApp herumliegen.
class JudoApp extends StatefulWidget {
  const JudoApp({super.key});

  @override
  State<JudoApp> createState() => _JudoAppState();
}

class _JudoAppState extends State<JudoApp> {
  late final Future<GuestChoiceStore> _guestChoiceFuture;
  AuthController? _authController;

  // Cache fuer die geladenen Daten-Controller, damit sie nicht bei jedem
  // Rebuild neu geladen werden - nur neu laden, wenn sich Gast/Konto-Status
  // tatsaechlich aendert (z.B. nach Anmeldung oder Abmeldung).
  String? _controllersKey;
  Future<(ProgressController, StreakController, FightLogController)>?
  _controllersFuture;

  @override
  void initState() {
    super.initState();
    _guestChoiceFuture = GuestChoiceStore.load();
  }

  @override
  void dispose() {
    _authController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GuestChoiceStore>(
      future: _guestChoiceFuture,
      builder: (context, snapshot) {
        final guestChoiceStore = snapshot.data;
        if (guestChoiceStore == null) return _loadingApp;

        // Nur beim allerersten erfolgreichen Snapshot erzeugen - der
        // FutureBuilder darf danach beliebig oft neu bauen, ohne den
        // Anmeldestatus zu verlieren.
        final authController = _authController ??= AuthController(
          AuthService(),
          guestChoiceStore,
        );
        return AuthScope(
          controller: authController,
          child: AnimatedBuilder(
            animation: authController,
            builder: (context, _) => _buildForStatus(authController),
          ),
        );
      },
    );
  }

  Widget _buildForStatus(AuthController authController) {
    switch (authController.status) {
      case AuthStatus.loading:
        return _loadingApp;
      case AuthStatus.needsChoice:
        return MaterialApp(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          theme: judoTheme,
          home: const WelcomeAuthScreen(),
        );
      case AuthStatus.disabled:
      case AuthStatus.guest:
      case AuthStatus.signedIn:
        return _buildAppShell(authController);
    }
  }

  Widget _buildAppShell(AuthController authController) {
    final isGuest = authController.status == AuthStatus.guest;
    final userId = authController.userId;
    final key = '$isGuest:$userId';
    if (_controllersKey != key) {
      _controllersKey = key;
      _controllersFuture = _loadControllers(isGuest: isGuest, userId: userId);
    }

    return FutureBuilder<
      (ProgressController, StreakController, FightLogController)
    >(
      future: _controllersFuture,
      builder: (context, snapshot) {
        final controllers = snapshot.data;
        if (controllers == null) return _loadingApp;
        final (progressController, streakController, fightLogController) =
            controllers;
        return ProgressScope(
          controller: progressController,
          child: StreakScope(
            controller: streakController,
            child: FightLogScope(
              controller: fightLogController,
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

  static Future<(ProgressController, StreakController, FightLogController)>
  _loadControllers({required bool isGuest, required String? userId}) async {
    if (isGuest) {
      return (
        ProgressController(ProgressStore.ephemeral()),
        StreakController(StreakStore.ephemeral()),
        FightLogController(FightLogStore.ephemeral()),
      );
    }

    final progressStore = await ProgressStore.load();
    final streakStore = await StreakStore.load();
    final fightLogStore = await FightLogStore.load();

    if (userId != null) {
      await _mergeCloudData(userId, progressStore, streakStore);
    }

    final progressController = ProgressController(progressStore);
    final streakController = StreakController(streakStore);
    final fightLogController = FightLogController(fightLogStore);

    if (userId != null) {
      progressController.addListener(
        () => CloudSync.push(userId, {
          'completed_items': progressStore.read().toList(),
        }),
      );
      streakController.addListener(
        () => CloudSync.push(userId, {
          'streak_current': streakStore.readCurrent(),
          'streak_longest': streakStore.readLongest(),
          'streak_last_active': streakStore.readLastActive(),
        }),
      );
    }

    return (progressController, streakController, fightLogController);
  }

  /// Uebernimmt Cloud-Daten in die lokalen Stores, bevor die Controller
  /// erzeugt werden - vereinigt den Lernfortschritt (nichts geht verloren),
  /// uebernimmt die Serie nur, wenn sie in der Cloud weiter ist. Das
  /// Wettkampf-Tagebuch bleibt bewusst rein lokal: die Eintraege verweisen
  /// auf lokale Fotopfade, die sich nicht sinnvoll zwischen Geraeten
  /// synchronisieren lassen.
  static Future<void> _mergeCloudData(
    String userId,
    ProgressStore progressStore,
    StreakStore streakStore,
  ) async {
    final cloud = await CloudSync.pull(userId);
    if (cloud == null) return;

    final cloudCompleted = (cloud['completed_items'] as List?)
        ?.whereType<String>()
        .toSet();
    if (cloudCompleted != null && cloudCompleted.isNotEmpty) {
      await progressStore.write({...progressStore.read(), ...cloudCompleted});
    }

    final cloudLongest = cloud['streak_longest'] as int?;
    final cloudCurrent = cloud['streak_current'] as int?;
    final cloudLastActive = cloud['streak_last_active'] as String?;
    if (cloudLongest != null &&
        cloudCurrent != null &&
        cloudLastActive != null &&
        cloudLongest >= streakStore.readLongest()) {
      await streakStore.write(
        current: cloudCurrent,
        longest: cloudLongest,
        lastActive: cloudLastActive,
      );
    }
  }
}
