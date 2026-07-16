import 'package:flutter/material.dart';

/// Wird nie tatsaechlich verwendet - Flutter unterstuetzt nur Plattformen,
/// fuer die hajime_sound_player_io.dart oder _web.dart einspringen. Dient
/// nur als von der Sprache geforderter Default fuer den bedingten Export.
class HajimeSoundPlayer {
  Future<void> play(BuildContext context) async {
    throw UnsupportedError('Plattform wird nicht unterstuetzt.');
  }

  void dispose() {}
}
