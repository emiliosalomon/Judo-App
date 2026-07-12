import 'dart:convert';
import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/fight_entry.dart';
import '../services/fight_log_controller.dart';
import '../services/fight_log_scope.dart';
import '../theme/judo_theme.dart';
import 'add_fight_screen.dart';

/// Persoenliches Wettkampf-Tagebuch: Liste aller eingetragenen Kaempfe,
/// mit Button zum Eintragen eines neuen Kampfs.
class MyFightsScreen extends StatelessWidget {
  const MyFightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FightLogScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.myFightsTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: AppStrings.addFightFabTooltip,
        backgroundColor: JudoColors.red,
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AddFightScreen())),
        child: const Icon(Icons.add, color: JudoColors.white),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final fights = controller.fights;
          if (fights.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  AppStrings.myFightsEmptyState,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            itemCount: fights.length,
            itemBuilder: (context, index) =>
                _FightCard(fight: fights[index], controller: controller),
          );
        },
      ),
    );
  }
}

class _FightCard extends StatelessWidget {
  final FightEntry fight;
  final FightLogController controller;

  const _FightCard({required this.fight, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fight.tournamentName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(_formatDate(fight.date)),
                      Text(fight.location),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: AppStrings.deleteFightTooltip,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
            if (fight.placement.isNotEmpty || fight.opponentsCount != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (fight.placement.isNotEmpty)
                      _Badge(text: fight.placement),
                    if (fight.opponentsCount != null)
                      _Badge(
                        text: AppStrings.fightOpponentsCountSummary(
                          fight.opponentsCount!,
                        ),
                      ),
                  ],
                ),
              ),
            if (fight.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(fight.notes),
              ),
            if (fight.photoBase64 != null || fight.bracketPhotoBase64 != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    if (fight.photoBase64 != null)
                      Expanded(child: _Thumbnail(base64: fight.photoBase64!)),
                    if (fight.photoBase64 != null &&
                        fight.bracketPhotoBase64 != null)
                      const SizedBox(width: 8),
                    if (fight.bracketPhotoBase64 != null)
                      Expanded(
                        child: _Thumbnail(base64: fight.bracketPhotoBase64!),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteFightConfirmTitle),
        content: const Text(AppStrings.deleteFightConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.deleteCancel),
          ),
          TextButton(
            onPressed: () {
              controller.removeFight(fight.id);
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              AppStrings.deleteConfirm,
              style: TextStyle(color: JudoColors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }
}

class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: JudoColors.black,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: JudoColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String base64;

  const _Thumbnail({required this.base64});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.memory(
        base64Decode(base64),
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
