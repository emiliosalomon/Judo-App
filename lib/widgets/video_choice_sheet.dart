import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/technique_video_data.dart';
import '../data/youtube_link.dart';
import '../l10n/strings.dart';

/// Oeffnet das Video zu [technique]. Gibt es dafuer sowohl einen
/// kuratierten Link als auch einen verifizierten Zeitstempel fuer den
/// "entscheidenden Moment" (siehe technique_video_data.dart), fragt vorher
/// ein Auswahlmenue, welcher der beiden geoeffnet werden soll. Sonst
/// oeffnet der Tap direkt den kuratierten Link bzw. eine YouTube-Suche.
Future<void> openTechniqueVideo(BuildContext context, String technique) async {
  final curated = findTechniqueVideo(technique);
  final moment = curated != null ? findTechniqueVideoMoment(technique) : null;

  Uri uri;
  if (curated != null && moment != null) {
    final choice = await showModalBottomSheet<_VideoChoice>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _VideoChoiceSheet(),
    );
    if (choice == null) return;
    uri = choice == _VideoChoice.moment
        ? Uri.parse('$curated&t=${moment}s')
        : Uri.parse(curated);
  } else {
    uri = curated != null ? Uri.parse(curated) : youtubeSearchUrl(technique);
  }

  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AppStrings.couldNotOpenLink)));
  }
}

enum _VideoChoice { moment, full }

class _VideoChoiceSheet extends StatelessWidget {
  const _VideoChoiceSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.center_focus_strong_outlined),
            title: const Text(AppStrings.videoChoiceMomentOption),
            onTap: () => Navigator.of(context).pop(_VideoChoice.moment),
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text(AppStrings.videoChoiceFullOption),
            onTap: () => Navigator.of(context).pop(_VideoChoice.full),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
