import 'package:flutter/widgets.dart';
import 'package:judo_app/services/fight_log_controller.dart';
import 'package:judo_app/services/fight_log_scope.dart';
import 'package:judo_app/services/fight_log_store.dart';
import 'package:judo_app/services/progress_controller.dart';
import 'package:judo_app/services/progress_scope.dart';
import 'package:judo_app/services/progress_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wickelt [child] in einen [ProgressScope] mit einem frischen,
/// leeren In-Memory-Fortschritt — fuer Widget-Tests, die Screens
/// rendern, welche auf ProgressScope.of(context) zugreifen.
Future<Widget> wrapWithProgress(Widget child) async {
  SharedPreferences.setMockInitialValues({});
  final store = await ProgressStore.load();
  return ProgressScope(controller: ProgressController(store), child: child);
}

/// Wickelt [child] in einen [FightLogScope] mit einem frischen, leeren
/// In-Memory-Tagebuch — fuer Widget-Tests von MyFightsScreen/AddFightScreen.
Future<Widget> wrapWithFightLog(Widget child) async {
  SharedPreferences.setMockInitialValues({});
  final store = await FightLogStore.load();
  return FightLogScope(controller: FightLogController(store), child: child);
}
