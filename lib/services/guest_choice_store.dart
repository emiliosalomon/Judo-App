import 'package:shared_preferences/shared_preferences.dart';

/// Persistiert lokal, ob zuletzt "Ohne Anmeldung fortfahren" gewaehlt wurde -
/// rein eine UI-Flow-Markierung, damit Gaeste nicht bei jedem App-Start
/// erneut gefragt werden. Enthaelt keine Lern-/Nutzerdaten.
class GuestChoiceStore {
  static const _key = 'auth_guest_mode_chosen';
  final SharedPreferences _prefs;

  GuestChoiceStore(this._prefs);

  static Future<GuestChoiceStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return GuestChoiceStore(prefs);
  }

  bool get isGuest => _prefs.getBool(_key) ?? false;

  Future<void> setGuest(bool value) => _prefs.setBool(_key, value);
}
