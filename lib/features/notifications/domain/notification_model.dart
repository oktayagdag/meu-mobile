import 'notification_type.dart';

/// Bildirim modeli.
///
/// Bu model hem mock veri hem REST API hem de
/// Firebase Cloud Messaging (FCM) ile uyumlu olacak
/// şekilde tasarlanmıştır.
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.route,
    this.imageUrl,
    this.payload,
  });

  /// Benzersiz bildirim kimliği
  final String id;

  /// Bildirim başlığı
  final String title;

  /// Bildirim açıklaması
  final String body;

  /// Bildirim tipi
  final NotificationType type;

  /// Oluşturulma zamanı
  final DateTime createdAt;

  /// Okundu bilgisi
  final bool isRead;

  /// Bildirime tıklanınca gidilecek route
  ///
  /// Örnek:
  ///
  /// /announcements
  /// /events
  /// /cafeteria
  final String? route;

  /// Opsiyonel görsel
  final String? imageUrl;

  /// İleride FCM veya API'den gelecek
  /// ekstra veriler.
  final Map<String, dynamic>? payload;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? route,
    String? imageUrl,
    Map<String, dynamic>? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      route: route ?? this.route,
      imageUrl: imageUrl ?? this.imageUrl,
      payload: payload ?? this.payload,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      route: json['route'] as String?,
      imageUrl: json['imageUrl'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'route': route,
      'imageUrl': imageUrl,
      'payload': payload,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return '''
NotificationModel(
  id: $id,
  title: $title,
  type: ${type.name},
  isRead: $isRead,
)
''';
  }
}
