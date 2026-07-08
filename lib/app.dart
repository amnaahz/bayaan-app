import 'package:bayaan/core/config/app_config.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/data/repositories/bayaan_repository.dart';
import 'package:bayaan/features/shell/app_shell.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Root widget. Provides the [AppState] controller and wires the light/dark
/// themes to the user's selection.
class BayaanApp extends StatelessWidget {
  const BayaanApp({
    required this.repository,
    required this.config,
    super.key,
  });

  final BayaanRepository repository;
  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(repository),
      child: Builder(
        builder: (context) {
          final themeMode = context.select<AppState, ThemeMode>(
            (s) => s.themeMode,
          );
          return MaterialApp(
            title: 'Bayaan',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
