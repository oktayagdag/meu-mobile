import 'package:dio/dio.dart';

enum NetworkErrorType {
  connection,
  timeout,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  server,
  invalidResponse,
  cancelled,
  unknown,
}

class NetworkException implements Exception {
  const NetworkException({
    required this.type,
    required this.title,
    required this.message,
    this.statusCode,
    this.originalError,
  });

  final NetworkErrorType type;
  final String title;
  final String message;
  final int? statusCode;
  final Object? originalError;

  factory NetworkException.fromObject(Object error) {
    if (error is NetworkException) {
      return error;
    }

    if (error is DioException) {
      return NetworkException.fromDioException(error);
    }

    if (error is FormatException) {
      return NetworkException(
        type: NetworkErrorType.invalidResponse,
        title: 'Veri okunamadı',
        message:
            'Sunucudan gelen veri beklenen formatta değil. Lütfen daha sonra tekrar dene.',
        originalError: error,
      );
    }

    return NetworkException(
      type: NetworkErrorType.unknown,
      title: 'Beklenmeyen hata',
      message:
          'Beklenmeyen bir hata oluştu. Lütfen uygulamayı yeniden deneyin.',
      originalError: error,
    );
  }

  factory NetworkException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return NetworkException(
          type: NetworkErrorType.timeout,
          title: 'Bağlantı zaman aşımına uğradı',
          message:
              'Sunucu yanıt vermekte gecikti. İnternet bağlantını kontrol edip tekrar dene.',
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          type: NetworkErrorType.connection,
          title: 'Bağlantı kurulamadı',
          message:
              'Sunucuya ulaşılamıyor. İnternet bağlantını ve API sunucusunun açık olduğunu kontrol et.',
          originalError: error,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          type: NetworkErrorType.connection,
          title: 'Güvenli bağlantı hatası',
          message:
              'Sunucu sertifikası doğrulanamadı. Lütfen bağlantıyı daha sonra tekrar dene.',
          originalError: error,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          type: NetworkErrorType.cancelled,
          title: 'İstek iptal edildi',
          message: 'İstek tamamlanmadan iptal edildi.',
          originalError: error,
        );

      case DioExceptionType.badResponse:
        return _fromStatusCode(error.response?.statusCode, error);

      case DioExceptionType.unknown:
        return NetworkException(
          type: NetworkErrorType.unknown,
          title: 'Beklenmeyen bağlantı hatası',
          message:
              'Sunucuya bağlanırken beklenmeyen bir hata oluştu. Lütfen tekrar dene.',
          originalError: error,
        );
    }
  }

  static NetworkException _fromStatusCode(int? statusCode, DioException error) {
    switch (statusCode) {
      case 400:
        return NetworkException(
          type: NetworkErrorType.badRequest,
          title: 'Geçersiz istek',
          message: 'Gönderilen istek sunucu tarafından kabul edilmedi.',
          statusCode: statusCode,
          originalError: error,
        );

      case 401:
        return NetworkException(
          type: NetworkErrorType.unauthorized,
          title: 'Oturum gerekli',
          message: 'Bu işlem için giriş yapman gerekiyor.',
          statusCode: statusCode,
          originalError: error,
        );

      case 403:
        return NetworkException(
          type: NetworkErrorType.forbidden,
          title: 'Yetki yok',
          message: 'Bu veriye erişim yetkin bulunmuyor.',
          statusCode: statusCode,
          originalError: error,
        );

      case 404:
        return NetworkException(
          type: NetworkErrorType.notFound,
          title: 'Veri bulunamadı',
          message: 'İstenen veri bulunamadı veya kaldırılmış olabilir.',
          statusCode: statusCode,
          originalError: error,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return NetworkException(
          type: NetworkErrorType.server,
          title: 'Sunucu hatası',
          message:
              'Sunucuda geçici bir sorun oluştu. Lütfen daha sonra tekrar dene.',
          statusCode: statusCode,
          originalError: error,
        );

      default:
        return NetworkException(
          type: NetworkErrorType.unknown,
          title: 'Sunucu yanıtı işlenemedi',
          message:
              'Sunucudan beklenmeyen bir yanıt alındı. Lütfen tekrar dene.',
          statusCode: statusCode,
          originalError: error,
        );
    }
  }

  @override
  String toString() {
    return 'NetworkException(type: $type, statusCode: $statusCode, message: $message)';
  }
}
