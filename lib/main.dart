import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/judo_theme.dart';

void main() {
  runApp(const JudoApp());
}

class JudoApp extends StatelessWidget {
  const JudoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Judo App',
      debugShowCheckedModeBanner: false,
      theme: judoTheme,
      home: const HomeScreen(),
    );
  }
}
