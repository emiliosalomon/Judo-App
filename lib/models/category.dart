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
    // 応用 (ōyō, "Anwendung") — eigene Bezeichnung fuer die OeJV-
    // "Anwendungsaufgaben", kein offizieller Kodokan-Fachbegriff.
    kanji: '応用',
    icon: Icons.compare_arrows,
  ),
  JudoCategory(
    id: 'quiz',
    titleDe: 'Technik-Quiz',
    // 問 (mon, "Frage") — passend zum Multiple-Choice-Format, kein
    // offizieller Kodokan-Fachbegriff.
    kanji: '問',
    icon: Icons.quiz,
  ),
  JudoCategory(
    id: 'rules',
    titleDe: 'Regelwerk',
    // 規則 (kisoku, "Regeln/Vorschriften") — Standardwort, kein
    // offizieller Kodokan-Fachbegriff.
    kanji: '規則',
    icon: Icons.gavel,
  ),
];
