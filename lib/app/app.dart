import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/splash/splash_screen.dart';

class DewmiiApp extends StatelessWidget {
  const DewmiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dewmii',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
