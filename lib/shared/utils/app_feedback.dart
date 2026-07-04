import 'package:flutter/material.dart';

void showAppSnackBar(
  BuildContext context, {
  required String message,
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

void showComingSoonSnackBar(
  BuildContext context, {
  required String featureName,
}) {
  showAppSnackBar(
    context,
    message: '$featureName yakında aktif olacak.',
  );
}