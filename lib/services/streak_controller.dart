import 'package:flutter/foundation.dart';
import 'streak_store.dart';

/// Zaehlt, an wie vielen Tagen in Folge die App geoeffnet wurde (Lern-Serie,
/// aehnlich der "Streak" in Sprachlern-Apps). Ein zweiter Besuch am selben
/// Tag zaehlt nicht doppelt, eine Luecke von mehr als einem Tag setzt die
/// Serie zurueck.
class StreakController extends ChangeNotifier {
  final StreakStore _store;
  final DateTime Function() now;
  late int _current;
  late int _longest;

  StreakController(this._store, {this.now = DateTime.now}) {
    _current = _store.readCurrent();
    _longest = _store.readLongest();
  }

  int get current => _current;
  int get longest => _longest;

  /// Beim App-Start (bzw. Betreten des Home-Screens) aufrufen, um die
  /// Serie fuer den heutigen Tag zu aktualisieren.
  Future<void> recordVisitToday() async {
    final today = _dateKey(now());
    final lastActive = _store.readLastActive();
    if (lastActive == today) return;

    final yesterday = _dateKey(now().subtract(const Duration(days: 1)));
    _current = lastActive == yesterday ? _current + 1 : 1;
    _longest = _current > _longest ? _current : _longest;

    await _store.write(current: _current, longest: _longest, lastActive: today);
    notifyListeners();
  }

  String _dateKey(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}
