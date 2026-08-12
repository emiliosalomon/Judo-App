import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/strings.dart';
import '../models/fight_entry.dart';
import '../services/fight_log_scope.dart';
import '../theme/judo_theme.dart';

/// Formular zum Eintragen eines neuen Kampfs ins Wettkampf-Tagebuch.
class AddFightScreen extends StatefulWidget {
  const AddFightScreen({super.key});

  @override
  State<AddFightScreen> createState() => _AddFightScreenState();
}

class _AddFightScreenState extends State<AddFightScreen> {
  final _tournamentController = TextEditingController();
  final _locationController = TextEditingController();
  final _placementController = TextEditingController();
  final _opponentsController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _date = DateTime.now();
  Uint8List? _photoBytes;
  Uint8List? _bracketPhotoBytes;
  String? _errorText;

  @override
  void dispose() {
    _tournamentController.dispose();
    _locationController.dispose();
    _placementController.dispose();
    _opponentsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickPhoto(ValueChanged<Uint8List?> onPicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    onPicked(bytes);
  }

  void _save() {
    final tournament = _tournamentController.text.trim();
    final location = _locationController.text.trim();
    if (tournament.isEmpty || location.isEmpty) {
      setState(() => _errorText = AppStrings.fightRequiredFieldsMissing);
      return;
    }
    final opponentsCount = int.tryParse(_opponentsController.text.trim());
    final fight = FightEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      date: _date,
      tournamentName: tournament,
      location: location,
      placement: _placementController.text.trim(),
      opponentsCount: opponentsCount,
      notes: _notesController.text.trim(),
      photoBase64: _photoBytes == null ? null : base64Encode(_photoBytes!),
      bracketPhotoBase64: _bracketPhotoBytes == null
          ? null
          : base64Encode(_bracketPhotoBytes!),
    );
    FightLogScope.of(context).addFight(fight);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addFightTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_errorText != null) ...[
            Text(_errorText!, style: const TextStyle(color: JudoColors.red)),
            const SizedBox(height: 12),
          ],
          Text(
            AppStrings.fightDateLabel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today),
            label: Text(_formatDate(_date)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tournamentController,
            decoration: const InputDecoration(
              labelText: AppStrings.fightTournamentLabel,
              hintText: AppStrings.fightTournamentHint,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: AppStrings.fightLocationLabel,
              hintText: AppStrings.fightLocationHint,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _placementController,
            decoration: const InputDecoration(
              labelText: AppStrings.fightPlacementLabel,
              hintText: AppStrings.fightPlacementHint,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _opponentsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: AppStrings.fightOpponentsCountLabel,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: AppStrings.fightNotesLabel,
              hintText: AppStrings.fightNotesHint,
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          _PhotoField(
            label: AppStrings.fightPhotoLabel,
            bytes: _photoBytes,
            onPick: () => _pickPhoto((b) => setState(() => _photoBytes = b)),
            onRemove: () => setState(() => _photoBytes = null),
          ),
          const SizedBox(height: 16),
          _PhotoField(
            label: AppStrings.fightBracketPhotoLabel,
            bytes: _bracketPhotoBytes,
            onPick: () =>
                _pickPhoto((b) => setState(() => _bracketPhotoBytes = b)),
            onRemove: () => setState(() => _bracketPhotoBytes = null),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
            child: const Text(AppStrings.saveFightButton),
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

class _PhotoField extends StatelessWidget {
  final String label;
  final Uint8List? bytes;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const _PhotoField({
    required this.label,
    required this.bytes,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (bytes != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              bytes!,
              height: 140,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(
                bytes == null
                    ? AppStrings.addPhotoButton
                    : AppStrings.changePhotoButton,
              ),
            ),
            if (bytes != null)
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline, color: JudoColors.red),
                label: const Text(
                  AppStrings.removePhotoButton,
                  style: TextStyle(color: JudoColors.red),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
