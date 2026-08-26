import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'transit_provider.dart';

final transitLocationProvider =
    AsyncNotifierProvider<TransitLocationNotifier, TransitLocationQuery>(
      TransitLocationNotifier.new,
    );

class TransitLocationNotifier extends AsyncNotifier<TransitLocationQuery> {
  @override
  Future<TransitLocationQuery> build() {
    return _getLocation();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _getLocation(preferCurrentLocation: true),
    );
  }

  Future<TransitLocationQuery> _getLocation({
    bool preferCurrentLocation = false,
  }) async {
    debugPrint('[TRANSIT LOCATION] Başladı');

    try {
      debugPrint('[TRANSIT LOCATION] Konum servisi kontrol ediliyor...');

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      debugPrint(
        '[TRANSIT LOCATION] '
        'Konum servisi: $serviceEnabled',
      );

      if (!serviceEnabled) {
        throw Exception(
          'Telefonun konum servisi kapalı. '
          'Konumu açıp tekrar dene.',
        );
      }

      debugPrint('[TRANSIT LOCATION] İzin kontrol ediliyor...');

      var permission = await Geolocator.checkPermission();

      debugPrint(
        '[TRANSIT LOCATION] '
        'Mevcut izin: $permission',
      );

      if (permission == LocationPermission.denied) {
        debugPrint(
          '[TRANSIT LOCATION] '
          'Konum izni isteniyor...',
        );

        permission = await Geolocator.requestPermission();

        debugPrint(
          '[TRANSIT LOCATION] '
          'Yeni izin: $permission',
        );
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Konum izni verilmedi.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Konum izni kalıcı olarak reddedilmiş. '
          'Telefon ayarlarından MEU Mobile için '
          'konum izni vermelisin.',
        );
      }

      // Sayfa ilk açıldığında önce hızlıca
      // cihazın son bildiği konumu kullanabiliriz.
      if (!preferCurrentLocation) {
        debugPrint(
          '[TRANSIT LOCATION] '
          'Son bilinen konum kontrol ediliyor...',
        );

        final lastPosition = await Geolocator.getLastKnownPosition();

        if (lastPosition != null) {
          debugPrint(
            '[TRANSIT LOCATION] '
            'Son bilinen konum bulundu: '
            '${lastPosition.latitude}, '
            '${lastPosition.longitude}',
          );

          return _toQuery(lastPosition);
        }

        debugPrint(
          '[TRANSIT LOCATION] '
          'Son bilinen konum yok.',
        );
      }

      debugPrint(
        '[TRANSIT LOCATION] '
        'Güncel GPS konumu isteniyor...',
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      debugPrint(
        '[TRANSIT LOCATION] '
        'Güncel konum bulundu: '
        '${position.latitude}, '
        '${position.longitude}',
      );

      return _toQuery(position);
    } on TimeoutException {
      debugPrint(
        '[TRANSIT LOCATION] '
        'GPS zaman aşımına uğradı.',
      );

      final fallback = await Geolocator.getLastKnownPosition();

      if (fallback != null) {
        debugPrint(
          '[TRANSIT LOCATION] '
          'Fallback konum kullanılıyor: '
          '${fallback.latitude}, '
          '${fallback.longitude}',
        );

        return _toQuery(fallback);
      }

      throw Exception(
        'Konum belirlenemedi. '
        'GPS sinyali alınamadı.',
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[TRANSIT LOCATION ERROR] '
        '$error',
      );

      debugPrint(
        '[TRANSIT LOCATION STACK] '
        '$stackTrace',
      );

      rethrow;
    }
  }

  TransitLocationQuery _toQuery(Position position) {
    return TransitLocationQuery(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
