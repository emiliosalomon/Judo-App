import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'guest_choice_store.dart';

/// - [disabled]: kein Firebase-Projekt konfiguriert - App verhaelt sich wie
///   vor Einfuehrung des Anmeldesystems (immer lokal persistiert, keine
///   Auswahl-Abfrage).
/// - [loading]: Anmeldestatus wird noch ermittelt.
/// - [needsChoice]: Firebase ist verfuegbar, aber weder angemeldet noch
///   Gast-Modus gewaehlt - Auswahlbildschirm zeigen.
/// - [guest]: "Ohne Anmeldung fortfahren" gewaehlt - Daten bleiben ephemer.
/// - [signedIn]: echtes Konto angemeldet - Daten werden lokal + in der
///   Cloud gespeichert.
enum AuthStatus { disabled, loading, needsChoice, guest, signedIn }

/// Verbindet [AuthService] (Firebase) mit [GuestChoiceStore] (lokale
/// Gast-Markierung) zu einem einzigen Anmeldestatus fuer die ganze App.
class AuthController extends ChangeNotifier {
  final AuthService _authService;
  final GuestChoiceStore _guestChoiceStore;
  StreamSubscription<User?>? _sub;
  AuthStatus _status = AuthStatus.loading;

  AuthController(this._authService, this._guestChoiceStore) {
    if (!_authService.isAvailable) {
      _status = AuthStatus.disabled;
      return;
    }
    _sub = _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  AuthStatus get status => _status;
  String? get userId => _authService.currentUserId;
  String? get userEmail => _authService.currentUserEmail;

  void _onAuthStateChanged(User? user) {
    if (user != null) {
      _status = AuthStatus.signedIn;
    } else if (_guestChoiceStore.isGuest) {
      _status = AuthStatus.guest;
    } else {
      _status = AuthStatus.needsChoice;
    }
    notifyListeners();
  }

  Future<String?> signIn(String email, String password) =>
      _authService.signIn(email.trim(), password);

  Future<String?> register(String email, String password) =>
      _authService.register(email.trim(), password);

  Future<void> continueAsGuest() async {
    await _guestChoiceStore.setGuest(true);
    _status = AuthStatus.guest;
    notifyListeners();
  }

  /// Zurueck zum Auswahlbildschirm, z.B. wenn ein Gast sich doch noch
  /// registrieren moechte.
  Future<void> leaveGuestMode() async {
    await _guestChoiceStore.setGuest(false);
    _status = AuthStatus.needsChoice;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _guestChoiceStore.setGuest(false);
    await _authService.signOut();
    // Falls Firebase keine eigene Aenderung meldet (z.B. Stream-Timing),
    // Status sicherheitshalber selbst zuruecksetzen.
    if (_status != AuthStatus.needsChoice) {
      _status = AuthStatus.needsChoice;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
