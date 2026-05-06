import 'package:flutter/material.dart';
import 'widgets/nav_shell.dart';

class Ink2LatexApp extends StatelessWidget {
  const Ink2LatexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ink2LaTeX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1a1a2e),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const NavShell(),
    );
  }
}