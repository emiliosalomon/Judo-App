import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/models/leaderboard_entry.dart';
import 'package:judo_app/screens/leaderboard_screen.dart';
import 'package:judo_app/services/leaderboard_repository.dart';
import 'package:judo_app/services/leaderboard_scope.dart';

import 'test_helpers.dart';

class _FakeLeaderboardRepository implements LeaderboardRepository {
  _FakeLeaderboardRepository({this.available = true});

  final bool available;
  final _entries = <String, LeaderboardEntry>{};
  final _controller = StreamController<List<LeaderboardEntry>>.broadcast();

  @override
  bool get isAvailable => available;

  @override
  String? get currentUserId => 'me';

  @override
  Future<void> submitScore({
    required String nickname,
    required int stars,
  }) async {
    _entries['me'] = LeaderboardEntry(
      userId: 'me',
      nickname: nickname,
      stars: stars,
    );
    _controller.add(_sorted());
  }

  List<LeaderboardEntry> _sorted() {
    final list = _entries.values.toList()
      ..sort((a, b) => b.stars.compareTo(a.stars));
    return list;
  }

  @override
  Stream<List<LeaderboardEntry>> watchTopEntries({int limit = 50}) async* {
    yield _sorted();
    yield* _controller.stream;
  }
}

void main() {
  testWidgets('zeigt Hinweis, wenn die Rangliste nicht verfuegbar ist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      await wrapWithProgress(
        MaterialApp(
          home: LeaderboardScope(
            repository: _FakeLeaderboardRepository(available: false),
            child: const LeaderboardScreen(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.leaderboardUnavailable), findsOneWidget);
  });

  testWidgets(
    'Beitreten mit Spitznamen sendet den aktuellen Sternestand und die '
    'eigene Zeile erscheint in der Liste',
    (WidgetTester tester) async {
      final fake = _FakeLeaderboardRepository();

      await tester.pumpWidget(
        await wrapWithProgress(
          MaterialApp(
            home: LeaderboardScope(
              repository: fake,
              child: const LeaderboardScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.leaderboardJoinButton), findsOneWidget);

      await tester.tap(find.text(AppStrings.leaderboardJoinButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Testo');
      await tester.tap(find.text(AppStrings.nicknamePromptConfirm));
      await tester.pumpAndSettle();

      expect(find.text('Testo'), findsOneWidget);
      // Frischer Fortschritt -> 0 Sterne.
      expect(find.text('0'), findsOneWidget);
    },
  );
}
