import 'package:flutter/material.dart';
import 'package:meu_mobile/app/router/app_router.dart';
import 'package:meu_mobile/app/theme/app_theme.dart';

class MeuMobileApp extends StatelessWidget {
  const MeuMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MEÜ Mobile',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
    );
  }
}