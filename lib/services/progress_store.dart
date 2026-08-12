import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert, welche Technik-/Grad-IDs der Nutzer als "gelernt" markiert
/// hat - entweder lokal auf dem Geraet, oder (im Gast-Modus des
/// Anmeldesystems) rein im Arbeitsspeicher, siehe [ProgressStore.ephemeral].
class ProgressStore {
  static const _key = 'completed_items';
  final SharedPreferences? _prefs;
  Set<String> _memory = const {};

  ProgressStore(SharedPreferences prefs) : _prefs = prefs;

  /// Keine Persistierung: Daten leben nur, solange die App laeuft. Fuer den
  /// Gast-Modus, in dem bewusst nichts gespeichert werden soll.
  ProgressStore.ephemeral() : _prefs = null;

  static Future<ProgressStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressStore(prefs);
  }

  Set<String> read() {
    final prefs = _prefs;
    if (prefs == null) return _memory;
    return (prefs.getStringList(_key) ?? const []).toSet();
  }

  Future<void> write(Set<String> completed) {
    final prefs = _prefs;
    if (prefs == null) {
      _memory = completed;
      return Future.value();
    }
    return prefs.setStringList(_key, completed.toList());
  }
}
