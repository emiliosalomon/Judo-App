import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert die Lern-Serie (an wie vielen Tagen in Folge die App genutzt
/// wurde) lokal auf dem Geraet.
class StreakStore {
  static const _currentKey = 'streak_current';
  static const _longestKey = 'streak_longest';
  static const _lastActiveKey = 'streak_last_active';
  final SharedPreferences _prefs;

  StreakStore(this._prefs);

  static Future<StreakStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return StreakStore(prefs);
  }

  int readCurrent() => _prefs.getInt(_currentKey) ?? 0;
  int readLongest() => _prefs.getInt(_longestKey) ?? 0;
  String? readLastActive() => _prefs.getString(_lastActiveKey);

  Future<void> write({
    required int current,
    required int longest,
    required String lastActive,
  }) async {
    await _prefs.setInt(_currentKey, current);
    await _prefs.setInt(_longestKey, longest);
    await _prefs.setString(_lastActiveKey, lastActive);
  }
}
