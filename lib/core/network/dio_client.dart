import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/network/api_endpoints.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,

      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 15),

      responseType: ResponseType.json,
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(_DebugDioLogger());
  }

  return dio;
});

class _DebugDioLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[API REQUEST] ${options.method} ${options.uri}');

    if (options.queryParameters.isNotEmpty) {
      debugPrint('[API QUERY] ${options.queryParameters}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    debugPrint(
      '[API RESPONSE] ${response.statusCode} ${response.requestOptions.uri}',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('[API ERROR] ${err.type} ${err.requestOptions.uri}');

    if (err.response != null) {
      debugPrint('[API ERROR STATUS] ${err.response?.statusCode}');
      debugPrint('[API ERROR DATA] ${err.response?.data}');
    } else {
      debugPrint('[API ERROR MESSAGE] ${err.message}');
    }

    super.onError(err, handler);
  }
}
