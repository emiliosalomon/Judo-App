import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fight_entry.dart';

/// Persistiert das Wettkampf-Tagebuch lokal auf dem Geraet (kein Backend,
/// keine Anmeldung) - wie [ProgressStore] auch, nur als JSON-Liste statt
/// als Menge von IDs.
class FightLogStore {
  static const _key = 'fight_log_entries';
  final SharedPreferences _prefs;

  FightLogStore(this._prefs);

  static Future<FightLogStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return FightLogStore(prefs);
  }

  List<FightEntry> read() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => FightEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> write(List<FightEntry> fights) {
    final encoded = jsonEncode(fights.map((f) => f.toJson()).toList());
    return _prefs.setString(_key, encoded);
  }
}
