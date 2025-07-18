class ApiConfig {
  // API Base URLs
  static const String localhost = 'http://localhost:3002';
  static const String localNetwork = 'http://192.168.1.11:3002';

  // Current API base URL - change this to switch between environments
  static const String baseUrl = localNetwork;

  // API Endpoints
  static const String scanEndpoint = '/api/scan';
  static const String healthEndpoint = '/health';

  // Full URLs
  static String get scanUrl => '$baseUrl$scanEndpoint';
  static String get healthUrl => '$baseUrl$healthEndpoint';

  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  // Timeout settings
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);
}
