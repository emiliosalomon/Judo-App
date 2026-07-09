import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/technique_media_data.dart';
import '../data/technique_video_data.dart';
import '../data/youtube_link.dart';
import '../l10n/strings.dart';
import '../theme/judo_theme.dart';

/// Zeigt zu einer einzelnen Technik/Aufgabe eine Illustration (falls
/// vorhanden) und einen Link zu einer YouTube-Suche dafuer.
class TechniqueMediaScreen extends StatelessWidget {
  final String technique;

  const TechniqueMediaScreen({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    final image = findTechniqueImage(technique);

    return Scaffold(
      appBar: AppBar(title: Text(technique)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (image != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image.url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    const _NoImagePlaceholder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppStrings.imageAttributionPrefix}${image.attribution}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else
            const _NoImagePlaceholder(),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _openYoutube(context),
            icon: const Icon(Icons.play_circle_outline),
            label: const Text(AppStrings.watchOnYoutube),
            style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
          ),
        ],
      ),
    );
  }

  Future<void> _openYoutube(BuildContext context) async {
    final curated = findTechniqueVideo(technique);
    final uri = curated != null
        ? Uri.parse(curated)
        : youtubeSearchUrl(technique);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.couldNotOpenLink)),
      );
    }
  }
}

class _NoImagePlaceholder extends StatelessWidget {
  const _NoImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: JudoColors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        AppStrings.noIllustrationYet,
        textAlign: TextAlign.center,
      ),
    );
  }
}
