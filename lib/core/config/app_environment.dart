final class AppEnvironment {
  const AppEnvironment._();

  static const String _definedApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  // Varsayılan olarak Railway canlı API adresi
  static const String _defaultApiBaseUrl =
      'https://meu-mobile-backend-production.up.railway.app/api/';

  static String get apiBaseUrl {
    final value = _definedApiBaseUrl.trim().isNotEmpty
        ? _definedApiBaseUrl.trim()
        : _defaultApiBaseUrl;

    return _withTrailingSlash(value);
  }

  static bool get hasCustomApiBaseUrl => _definedApiBaseUrl.trim().isNotEmpty;

  static String _withTrailingSlash(String value) {
    if (value.endsWith('/')) return value;
    return '$value/';
  }
}
