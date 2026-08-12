import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert die Lern-Serie (an wie vielen Tagen in Folge die App genutzt
/// wurde) - entweder lokal auf dem Geraet, oder (im Gast-Modus des
/// Anmeldesystems) rein im Arbeitsspeicher, siehe [StreakStore.ephemeral].
class StreakStore {
  static const _currentKey = 'streak_current';
  static const _longestKey = 'streak_longest';
  static const _lastActiveKey = 'streak_last_active';
  final SharedPreferences? _prefs;
  int _memoryCurrent = 0;
  int _memoryLongest = 0;
  String? _memoryLastActive;

  StreakStore(SharedPreferences prefs) : _prefs = prefs;

  /// Keine Persistierung: Daten leben nur, solange die App laeuft. Fuer den
  /// Gast-Modus, in dem bewusst nichts gespeichert werden soll.
  StreakStore.ephemeral() : _prefs = null;

  static Future<StreakStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return StreakStore(prefs);
  }

  int readCurrent() => _prefs?.getInt(_currentKey) ?? _memoryCurrent;
  int readLongest() => _prefs?.getInt(_longestKey) ?? _memoryLongest;
  String? readLastActive() =>
      _prefs?.getString(_lastActiveKey) ?? _memoryLastActive;

  Future<void> write({
    required int current,
    required int longest,
    required String lastActive,
  }) async {
    final prefs = _prefs;
    if (prefs == null) {
      _memoryCurrent = current;
      _memoryLongest = longest;
      _memoryLastActive = lastActive;
      return;
    }
    await prefs.setInt(_currentKey, current);
    await prefs.setInt(_longestKey, longest);
    await prefs.setString(_lastActiveKey, lastActive);
  }
}
