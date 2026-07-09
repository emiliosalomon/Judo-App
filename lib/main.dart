import 'package:flutter/material.dart';
import 'l10n/strings.dart';
import 'screens/home_screen.dart';
import 'services/progress_controller.dart';
import 'services/progress_scope.dart';
import 'services/progress_store.dart';
import 'theme/judo_theme.dart';

void main() {
  runApp(const JudoApp());
}

class JudoApp extends StatelessWidget {
  const JudoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProgressStore>(
      future: ProgressStore.load(),
      builder: (context, snapshot) {
        final store = snapshot.data;
        if (store == null) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return ProgressScope(
          controller: ProgressController(store),
          child: MaterialApp(
            title: AppStrings.appTitle,
            debugShowCheckedModeBanner: false,
            theme: judoTheme,
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
