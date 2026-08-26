import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/app/app.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('tr');

  runApp(
    ProviderScope(
      retry: (retryCount, error) {
        if (kDebugMode) {
          return null;
        }

        if (retryCount >= 1) {
          return null;
        }

        return const Duration(seconds: 1);
      },
      child: const MeuMobileApp(),
    ),
  );
}
