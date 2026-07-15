import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Kapselt das Abspielen der "Hajime!"-Sprachaufnahme inkl. Fehlerbehandlung,
/// damit mehrere Screens (Logo-Tap, Quiz-Rundenstart) dieselbe Logik nutzen
/// statt sie zu duplizieren. Jede Nutzungsstelle haelt eine eigene Instanz
/// (an ihren State-Lifecycle gebunden, siehe [dispose]).
class HajimeSoundPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(BuildContext context) async {
    try {
      // Kein manuelles stop() davor: play() uebernimmt das Stoppen/
      // Neustarten schon selbst (setSource + resume). Ein stop() auf einem
      // Player ohne bisherige Quelle kann je nach Plattform werfen - dann
      // wuerde dieser try-Block schon vor play() abbrechen und nie Ton
      // ausgeben, ohne dass davon ausserhalb des Debug-Logs etwas sichtbar
      // waere.
      await _player.play(AssetSource('audio/hajime.m4a'));
    } catch (error) {
      // Ton ist reine Zugabe – Wiedergabefehler (z.B. kein Audio-Output)
      // duerfen die Bedienung nicht stoeren. Zusaetzlich zum Debug-Log auch
      // sichtbar auf dem Screen (SnackBar), da auf einem Geraet ohne
      // angeschlossene Entwickler-Konsole sonst niemand den Fehler sieht.
      debugPrint('Hajime-Sound konnte nicht abgespielt werden: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hajime-Sound-Fehler: $error')));
      }
    }
  }

  void dispose() => _player.dispose();
}
