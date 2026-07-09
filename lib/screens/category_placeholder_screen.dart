import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/category.dart';

class CategoryPlaceholderScreen extends StatelessWidget {
  final JudoCategory category;

  const CategoryPlaceholderScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.titleDe)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 64),
              const SizedBox(height: 16),
              Text(
                '${category.titleDe} (${category.kanji})',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.contentComingSoon,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
