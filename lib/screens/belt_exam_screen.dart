import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../data/kyu_grades_data.dart';
import '../l10n/strings.dart';
import '../services/progress_scope.dart';
import '../theme/belt_colors.dart';
import '../theme/judo_theme.dart';
import '../widgets/belt_knot_icon.dart';
import '../widgets/stats_banner.dart';
import 'dan_grade_detail_screen.dart';
import 'kyu_grade_detail_screen.dart';

class BeltExamScreen extends StatelessWidget {
  const BeltExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.beltExamTitle),
          bottom: const TabBar(
            tabs: [
              Tab(text: AppStrings.tabKyu),
              Tab(text: AppStrings.tabDan),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Builder(
              builder: (context) {
                final progress = ProgressScope.of(context);
                return ListView.builder(
                  itemCount: judoKyuGrades.length,
                  itemBuilder: (context, index) {
                    final grade = judoKyuGrades[index];
                    final total = kyuTrackableCount(grade);
                    final done = progress.countCompletedWithPrefix(
                      'kyu:${grade.kyu}:',
                    );
                    final complete = total > 0 && done == total;
                    return ListTile(
                      leading: BeltKnotIcon(
                        colors: beltColorsFromName(grade.beltName),
                        size: 36,
                      ),
                      title: Text(grade.title),
                      subtitle: grade.minAge != null
                          ? Text(AppStrings.minAgeSubtitle(grade.minAge!))
                          : null,
                      trailing: total > 0
                          ? _ProgressTrailing(
                              done: done,
                              total: total,
                              complete: complete,
                            )
                          : const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => KyuGradeDetailScreen(grade: grade),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                final progress = ProgressScope.of(context);
                return ListView.builder(
                  itemCount: judoDanGrades.length,
                  itemBuilder: (context, index) {
                    final grade = judoDanGrades[index];
                    final total = grade.zusatztechniken.length;
                    final done = progress.countCompletedWithPrefix(
                      'dan:${grade.dan}:',
                    );
                    final complete = total > 0 && done == total;
                    return ListTile(
                      leading: BeltKnotIcon(
                        colors: beltColorsFromName(grade.beltDescription),
                        size: 36,
                      ),
                      title: Text(grade.title),
                      subtitle: Text(grade.kata ?? grade.beltDescription),
                      trailing: total > 0
                          ? _ProgressTrailing(
                              done: done,
                              total: total,
                              complete: complete,
                            )
                          : const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DanGradeDetailScreen(grade: grade),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTrailing extends StatelessWidget {
  final int done;
  final int total;
  final bool complete;

  const _ProgressTrailing({
    required this.done,
    required this.total,
    required this.complete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (complete)
          Tooltip(
            message: AppStrings.beltCompleteBadge,
            child: const Icon(
              Icons.emoji_events_rounded,
              color: JudoColors.gold,
              size: 34,
            ),
          ),
        Text(AppStrings.progressFraction(done, total)),
      ],
    );
  }
}
