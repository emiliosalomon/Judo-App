/// Kapselt das Abspielen der "Hajime!"-Sprachaufnahme inkl. Fehlerbehandlung,
/// damit mehrere Screens (Logo-Tap, Quiz-Rundenstart) dieselbe Logik nutzen
/// statt sie zu duplizieren. Jede Nutzungsstelle haelt eine eigene Instanz
/// (an ihren State-Lifecycle gebunden, siehe dispose()).
///
/// Web bekommt eine eigene Implementierung (natives <audio>-Element statt
/// des audioplayers-Plugins) - siehe hajime_sound_player_web.dart fuer den
/// Hintergrund.
library;

export 'hajime_sound_player_stub.dart'
    if (dart.library.html) 'hajime_sound_player_web.dart'
    if (dart.library.io) 'hajime_sound_player_io.dart';
