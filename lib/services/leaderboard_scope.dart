import 'package:flutter/widgets.dart';
import 'leaderboard_repository.dart';

/// Stellt das [LeaderboardRepository] app-weit ueber den BuildContext
/// bereit (analog zu ProgressScope/StreakScope).
class LeaderboardScope extends InheritedWidget {
  final LeaderboardRepository repository;

  const LeaderboardScope({
    super.key,
    required this.repository,
    required super.child,
  });

  static LeaderboardRepository of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<LeaderboardScope>();
    assert(scope != null, 'No LeaderboardScope found in context');
    return scope!.repository;
  }

  @override
  bool updateShouldNotify(LeaderboardScope oldWidget) =>
      repository != oldWidget.repository;
}
