import 'package:flutter/material.dart';

import 'config/app_notifiers.dart';
import 'config/router/router.dart';

class ParcialFlutterApp extends StatelessWidget {
  const ParcialFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          title: 'Parcial Flutter',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: const Color(0xFF1E3A8A),
          ),
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
