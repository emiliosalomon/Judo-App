import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert den selbstgewaehlten Rangliste-Nickname lokal auf dem
/// Geraet, damit er nicht bei jedem App-Start erneut abgefragt wird.
class NicknameStore {
  static const _key = 'leaderboard_nickname';
  final SharedPreferences _prefs;

  NicknameStore(this._prefs);

  static Future<NicknameStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return NicknameStore(prefs);
  }

  String? read() => _prefs.getString(_key);

  Future<void> write(String nickname) => _prefs.setString(_key, nickname);
}
