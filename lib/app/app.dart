import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/app/router/app_router.dart';
import 'package:meu_mobile/app/theme/app_theme.dart';
import 'package:meu_mobile/features/settings/application/providers/settings_provider.dart';

class MeuMobileApp extends ConsumerWidget {
  const MeuMobileApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);

    final themeMode = settingsAsync.maybeWhen(
      data: (settings) {
        return settings.themePreference.themeMode;
      },
      orElse: () => ThemeMode.system,
    );

    return MaterialApp.router(
      title: 'MEÜ Mobile',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
    );
  }
}
