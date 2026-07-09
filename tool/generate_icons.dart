// Hilfsskript, um App-Icons aus JudoThrowPainter zu rendern/neu zu rendern.
// Kein regulaerer Test - ausfuehren mit:
//   flutter test tool/generate_icons.dart
// Sobald echtes Logo-Artwork vorliegt, wird dieses Skript ueberfluessig.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/theme/judo_theme.dart';
import 'package:judo_app/widgets/judo_throw_painter.dart';

class _IconSpec {
  final String path;
  final int size;
  const _IconSpec(this.path, this.size);
}

const _specs = <_IconSpec>[
  // Android mipmaps
  _IconSpec('android/app/src/main/res/mipmap-mdpi/ic_launcher.png', 48),
  _IconSpec('android/app/src/main/res/mipmap-hdpi/ic_launcher.png', 72),
  _IconSpec('android/app/src/main/res/mipmap-xhdpi/ic_launcher.png', 96),
  _IconSpec('android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png', 144),
  _IconSpec('android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png', 192),
  // iOS AppIcon.appiconset
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png',
    20,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png',
    40,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png',
    60,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png',
    29,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png',
    58,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png',
    87,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png',
    40,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png',
    80,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png',
    120,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png',
    120,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png',
    180,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png',
    76,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png',
    152,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png',
    167,
  ),
  _IconSpec(
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png',
    1024,
  ),
  // Web
  _IconSpec('web/icons/Icon-192.png', 192),
  _IconSpec('web/icons/Icon-512.png', 512),
  _IconSpec('web/icons/Icon-maskable-192.png', 192),
  _IconSpec('web/icons/Icon-maskable-512.png', 512),
  _IconSpec('web/favicon.png', 64),
];

Future<void> _renderIcon(
  _IconSpec spec, {
  bool maskableSafeZone = false,
}) async {
  final size = spec.size.toDouble();
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Voller roter Hintergrund (kein Weiss/Ring wie im In-App-Logo, damit es
  // als App-Icon auf jedem Homescreen-Hintergrund funktioniert).
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size, size),
    Paint()..color = JudoColors.red,
  );

  // Maskable-Icons brauchen mehr Rand (sichere Zone ca. 20%), normale Icons
  // duerfen randnaeher gehen.
  final pad = size * (maskableSafeZone ? 0.22 : 0.1);
  canvas.save();
  canvas.translate(pad, pad);
  const JudoThrowPainter().paint(canvas, Size(size - 2 * pad, size - 2 * pad));
  canvas.restore();

  final picture = recorder.endRecording();
  final image = await picture.toImage(spec.size, spec.size);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File(spec.path);
  await file.parent.create(recursive: true);
  await file.writeAsBytes(byteData!.buffer.asUint8List());
}

void main() {
  test('generate app icons from JudoThrowPainter', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final spec in _specs) {
      await _renderIcon(spec, maskableSafeZone: spec.path.contains('maskable'));
    }
    // ignore: avoid_print
    print('Generated ${_specs.length} icon files.');
  });
}
