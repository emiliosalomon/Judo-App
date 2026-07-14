import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fight_entry.dart';

/// Persistiert das Wettkampf-Tagebuch - entweder lokal auf dem Geraet, oder
/// (im Gast-Modus des Anmeldesystems) rein im Arbeitsspeicher, siehe
/// [FightLogStore.ephemeral]. Wie [ProgressStore] auch, nur als JSON-Liste
/// statt als Menge von IDs.
class FightLogStore {
  static const _key = 'fight_log_entries';
  final SharedPreferences? _prefs;
  List<FightEntry> _memory = const [];

  FightLogStore(SharedPreferences prefs) : _prefs = prefs;

  /// Keine Persistierung: Daten leben nur, solange die App laeuft. Fuer den
  /// Gast-Modus, in dem bewusst nichts gespeichert werden soll.
  FightLogStore.ephemeral() : _prefs = null;

  static Future<FightLogStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return FightLogStore(prefs);
  }

  List<FightEntry> read() {
    final prefs = _prefs;
    if (prefs == null) return _memory;
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => FightEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> write(List<FightEntry> fights) {
    final prefs = _prefs;
    if (prefs == null) {
      _memory = fights;
      return Future.value();
    }
    final encoded = jsonEncode(fights.map((f) => f.toJson()).toList());
    return prefs.setString(_key, encoded);
  }
}
