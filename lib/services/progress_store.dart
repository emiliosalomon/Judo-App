import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert, welche Technik-/Grad-IDs der Nutzer als "gelernt" markiert
/// hat. Speichert lokal auf dem Geraet (kein Backend, keine Anmeldung).
class ProgressStore {
  static const _key = 'completed_items';
  final SharedPreferences _prefs;

  ProgressStore(this._prefs);

  static Future<ProgressStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressStore(prefs);
  }

  Set<String> read() => (_prefs.getStringList(_key) ?? const []).toSet();

  Future<void> write(Set<String> completed) {
    return _prefs.setStringList(_key, completed.toList());
  }
}
