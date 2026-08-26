import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';

class RingRouteModel {
  const RingRouteModel({
    required this.id,
    required this.from,
    required this.to,
    required this.remainingMinute,
    required this.frequencyText,
    required this.isFavorite,
  });

  final String id;
  final String from;
  final String to;
  final int remainingMinute;
  final String frequencyText;
  final bool isFavorite;

  factory RingRouteModel.fromJson(Map<String, dynamic> json) {
    return RingRouteModel(
      id: json['id']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
      remainingMinute:
          int.tryParse(json['remainingMinute']?.toString() ?? '') ??
          int.tryParse(json['remaining_minute']?.toString() ?? '') ??
          0,
      frequencyText:
          json['frequencyText']?.toString() ??
          json['frequency_text']?.toString() ??
          '',
      isFavorite: _parseBool(json['isFavorite'] ?? json['is_favorite']),
    );
  }

  RingRouteEntity toEntity() {
    return RingRouteEntity(
      from: from,
      to: to,
      remainingMinute: remainingMinute,
      frequencyText: frequencyText,
      isFavorite: isFavorite,
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final normalized = value?.toString().toLowerCase();

    return normalized == 'true' || normalized == '1';
  }
}
