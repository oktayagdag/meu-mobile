import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meu_mobile/core/network/dio_client.dart';
import 'package:meu_mobile/features/ring/data/datasources/transit_remote_data_source.dart';
import 'package:meu_mobile/features/ring/data/repositories/transit_repository_impl.dart';
import 'package:meu_mobile/features/ring/domain/entities/transit_dashboard_entity.dart';
import 'package:meu_mobile/features/ring/domain/entities/transit_line_tracking_entity.dart';
import 'package:meu_mobile/features/ring/domain/repositories/transit_repository.dart';

final transitRemoteDataSourceProvider = Provider<TransitRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);

  return TransitRemoteDataSourceImpl(dio);
});

final transitRepositoryProvider = Provider<TransitRepository>((ref) {
  final remoteDataSource = ref.watch(transitRemoteDataSourceProvider);

  return TransitRepositoryImpl(remoteDataSource);
});

class TransitLocationQuery {
  const TransitLocationQuery({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) {
    return other is TransitLocationQuery &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

final transitDashboardProvider =
    FutureProvider.family<TransitDashboardEntity, TransitLocationQuery>((
      ref,
      location,
    ) async {
      final repository = ref.watch(transitRepositoryProvider);

      return repository.getDashboard(
        latitude: location.latitude,
        longitude: location.longitude,
      );
    });

final transitLineStopsProvider =
    FutureProvider.autoDispose.family<List<TransitRouteStopEntity>, String>((
      ref,
      lineKey,
    ) async {
      final repository = ref.watch(transitRepositoryProvider);

      return repository.getLineStops(
        lineKey: lineKey,
      );
    });

final transitLineVehiclesProvider =
    FutureProvider.autoDispose.family<List<TransitLiveVehicleEntity>, String>((
      ref,
      lineKey,
    ) async {
      final repository = ref.watch(transitRepositoryProvider);

      final vehicles = await repository.getLineVehicles(
        lineKey: lineKey,
      );

      // Bir sonraki canlı sorgu.
      final timer = Timer(
        const Duration(seconds: 10),
        ref.invalidateSelf,
      );

      ref.onDispose(
        timer.cancel,
      );

      return vehicles;
    });
