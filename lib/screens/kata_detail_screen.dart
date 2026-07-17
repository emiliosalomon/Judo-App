import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/kata_video_data.dart';
import '../data/technique_translations_data.dart';
import '../data/youtube_link.dart';
import '../l10n/strings.dart';
import '../models/kata_info.dart';
import '../theme/judo_theme.dart';
import '../widgets/video_choice_sheet.dart';

class KataDetailScreen extends StatelessWidget {
  final KataInfo info;
  final String requiredForGrade;

  const KataDetailScreen({
    super.key,
    required this.info,
    required this.requiredForGrade,
  });

  @override
  Widget build(BuildContext context) {
    final fullVideoUrl = kataFullVideos[info.name];

    return Scaffold(
      appBar: AppBar(title: Text(info.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (info.overviewImage != null) ...[
            AspectRatio(
              // Feste Seitenverhaeltnis-Vorgabe, weil Image ohne definierte
              // Groesse innerhalb einer ListView (unbegrenzte Hoehe) sonst
              // auf Groesse 0 kollabiert und gar nicht angezeigt wird.
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: info.overviewImage!.build(),
              ),
            ),
            if (info.overviewImage!.attribution != null) ...[
              const SizedBox(height: 4),
              Text(
                '${AppStrings.imageAttributionPrefix}${info.overviewImage!.attribution}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
          ],
          if (fullVideoUrl != null) ...[
            FilledButton.icon(
              onPressed: () => _open(context, Uri.parse(fullVideoUrl)),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text(AppStrings.watchFullKataOnYoutube),
              style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.kataVideoAttribution,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            info.meaning,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: JudoColors.red,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(AppStrings.requiredForGrade(requiredForGrade)),
          const SizedBox(height: 16),
          Text(info.description),
          const SizedBox(height: 20),
          const Text(
            AppStrings.kataTechniquesLabel,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            AppStrings.kataTechniqueVideoHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          for (final section in info.sections)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  for (final technique in section.techniques)
                    Builder(
                      builder: (context) {
                        final translation = translateTechnique(technique);
                        return InkWell(
                          onTap: () => chooseTechniqueVideo(
                            context,
                            technique,
                            noCuratedMatchFallback: (t) =>
                                kodokanChannelSearchUrl('$t ${info.name}'),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${AppStrings.bullet}$technique'),
                                      if (translation != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child: Text(
                                            translation,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.play_circle_outline,
                                  size: 20,
                                  color: JudoColors.red,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _open(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.couldNotOpenLink)),
      );
    }
  }
}
