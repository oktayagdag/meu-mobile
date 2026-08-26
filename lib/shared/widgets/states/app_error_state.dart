import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/core/network/network_exception.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({required this.error, this.onRetry, super.key});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final exception = NetworkException.fromObject(error);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmptyState(
          title: exception.title,
          description: exception.message,
          icon: _iconForType(exception.type),
        ),

        if (onRetry != null) ...[
          const Gap(AppSpacing.md),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ],
    );
  }

  IconData _iconForType(NetworkErrorType type) {
    switch (type) {
      case NetworkErrorType.connection:
        return Icons.wifi_off_rounded;

      case NetworkErrorType.timeout:
        return Icons.timer_off_rounded;

      case NetworkErrorType.badRequest:
        return Icons.warning_amber_rounded;

      case NetworkErrorType.unauthorized:
        return Icons.lock_outline_rounded;

      case NetworkErrorType.forbidden:
        return Icons.block_rounded;

      case NetworkErrorType.notFound:
        return Icons.search_off_rounded;

      case NetworkErrorType.server:
        return Icons.cloud_off_rounded;

      case NetworkErrorType.invalidResponse:
        return Icons.data_object_rounded;

      case NetworkErrorType.cancelled:
        return Icons.cancel_outlined;

      case NetworkErrorType.unknown:
        return Icons.error_outline_rounded;
    }
  }
}
