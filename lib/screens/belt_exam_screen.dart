import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../data/kyu_grades_data.dart';
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
          title: const Text('Gürtelprüfung'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Kyu (Schülergrade)'), Tab(text: 'Dan (Meistergrade)')],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: judoKyuGrades.length,
              itemBuilder: (context, index) {
                final grade = judoKyuGrades[index];
                return ListTile(
                  title: Text(grade.title),
                  subtitle: grade.minAge != null
                      ? Text('ab ${grade.minAge} Jahren')
                      : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => KyuGradeDetailScreen(grade: grade),
                    ),
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: judoDanGrades.length,
              itemBuilder: (context, index) {
                final grade = judoDanGrades[index];
                return ListTile(
                  title: Text(grade.title),
                  subtitle: Text(grade.kata ?? grade.beltDescription),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DanGradeDetailScreen(grade: grade),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
