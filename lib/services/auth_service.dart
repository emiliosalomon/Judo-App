import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Duenner Wrapper um FirebaseAuth. Greift nie auf FirebaseAuth.instance zu,
/// ohne vorher [isAvailable] zu pruefen: solange kein echtes Firebase-Projekt
/// konfiguriert ist (siehe main.dart), bleibt die App voll nutzbar - Login/
/// Registrierung liefern nur einen Fehlertext statt zu crashen.
class AuthService {
  bool get isAvailable => Firebase.apps.isNotEmpty;

  Stream<User?> get authStateChanges => isAvailable
      ? FirebaseAuth.instance.authStateChanges()
      : Stream.value(null);

  String? get currentUserId =>
      isAvailable ? FirebaseAuth.instance.currentUser?.uid : null;

  String? get currentUserEmail =>
      isAvailable ? FirebaseAuth.instance.currentUser?.email : null;

  /// Gibt bei Erfolg null zurueck, sonst eine nutzerlesbare Fehlermeldung.
  Future<String?> register(String email, String password) async {
    if (!isAvailable) return _unavailableMessage;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _messageFor(e);
    } catch (_) {
      return _genericError;
    }
  }

  /// Gibt bei Erfolg null zurueck, sonst eine nutzerlesbare Fehlermeldung.
  Future<String?> signIn(String email, String password) async {
    if (!isAvailable) return _unavailableMessage;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _messageFor(e);
    } catch (_) {
      return _genericError;
    }
  }

  Future<void> signOut() async {
    if (!isAvailable) return;
    await FirebaseAuth.instance.signOut();
  }

  static const _unavailableMessage = 'Anmeldung ist aktuell nicht verfügbar.';
  static const _genericError =
      'Das hat leider nicht geklappt. Bitte später erneut versuchen.';

  String _messageFor(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Für diese E-Mail-Adresse existiert bereits ein Konto.';
      case 'invalid-email':
        return 'Bitte eine gültige E-Mail-Adresse eingeben.';
      case 'weak-password':
        return 'Das Passwort ist zu schwach (mind. 6 Zeichen).';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-Mail-Adresse oder Passwort ist falsch.';
      case 'too-many-requests':
        return 'Zu viele Versuche. Bitte kurz warten und erneut versuchen.';
      default:
        return _genericError;
    }
  }
}
