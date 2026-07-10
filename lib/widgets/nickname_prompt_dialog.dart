import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../theme/judo_theme.dart';

/// Fragt einen Spitznamen fuer die Rangliste ab. Liefert null bei Abbruch.
Future<String?> showNicknamePrompt(
  BuildContext context, {
  String? initialValue,
}) {
  final controller = TextEditingController(text: initialValue ?? '');
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(AppStrings.nicknamePromptTitle),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 20,
        decoration: const InputDecoration(
          hintText: AppStrings.nicknamePromptHint,
        ),
        onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.nicknamePromptCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
          child: const Text(AppStrings.nicknamePromptConfirm),
        ),
      ],
    ),
  );
}
