// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
// dart:html ist fuer neuen Code zwar zugunsten von package:web/js_interop
// als bevorzugt-vermeiden markiert, funktioniert aber weiterhin und ist
// fuer dieses eine <audio>-Element deutlich einfacher - diese Datei wird
// ausschliesslich fuer das Web-Ziel kompiliert (siehe conditional export
// in hajime_sound_player.dart), daher ist Web-only-Code hier beabsichtigt.
import 'dart:html' as html;
import 'package:flutter/material.dart';

/// Web-Implementierung ueber ein natives <audio>-Element statt ueber das
/// audioplayers-Plugin: dessen MethodChannel-basierte Web-Anbindung
/// (xyz.luan/audioplayers.global) wirft im Produktions-Build zuverlaessig
/// MissingPluginException (bekanntes audioplayers/Flutter-Web-Problem -
/// die Plugin-Registrierung fuer Web-Ziele ist fragil, siehe
/// github.com/bluefireteam/audioplayers/issues/1617). Ein <audio>-Element
/// braucht keine Plugin-Registrierung und ist fuer diesen einen kurzen
/// Sound-Effekt voellig ausreichend.
class HajimeSoundPlayer {
  html.AudioElement? _audio;

  Future<void> play(BuildContext context) async {
    try {
      final audio = _audio ??= (html.AudioElement(
        'assets/assets/audio/hajime.m4a',
      )..preload = 'auto');
      audio.currentTime = 0;
      await audio.play();
    } catch (error) {
      debugPrint('Hajime-Sound konnte nicht abgespielt werden: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hajime-Sound-Fehler: $error')));
      }
    }
  }

  void dispose() => _audio?.remove();
}
