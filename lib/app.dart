import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/views/main_shell_screen.dart';

/// Root application widget.
class NordicFocusApp extends StatelessWidget {
  const NordicFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nordic Focus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShellScreen(),
    );
  }
}
