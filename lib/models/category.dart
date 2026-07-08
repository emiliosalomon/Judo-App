import 'package:flutter/material.dart';

class JudoCategory {
  final String id;
  final String titleDe;
  final String kanji;
  final IconData icon;

  const JudoCategory({
    required this.id,
    required this.titleDe,
    required this.kanji,
    required this.icon,
  });
}

const judoCategories = <JudoCategory>[
  JudoCategory(
    id: 'belt-exam',
    titleDe: 'Gürtelprüfung',
    kanji: '帯',
    icon: Icons.military_tech,
  ),
  JudoCategory(
    id: 'techniques',
    titleDe: 'Weiterführende Techniken',
    kanji: '技',
    icon: Icons.sports_martial_arts,
  ),
  JudoCategory(
    id: 'kata',
    titleDe: 'Kata',
    kanji: '形',
    icon: Icons.self_improvement,
  ),
  JudoCategory(
    id: 'standard-situations',
    titleDe: 'Standardsituationen',
    kanji: '護身',
    icon: Icons.shield_outlined,
  ),
  JudoCategory(
    id: 'search',
    titleDe: 'Suche',
    kanji: '検索',
    icon: Icons.search,
  ),
];
