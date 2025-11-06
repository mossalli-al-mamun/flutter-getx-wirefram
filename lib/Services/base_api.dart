import '../Config/flavor.dart';

class BaseApi {
  static String? baseUrl = FlavorConfig.isProduction ? 'https://moucii.com' : 'https://moucii.com';
  static String appFlavor = FlavorConfig.flavorString;

  static final String api = '/api/v1/';

  // Helper method to build endpoints
  static String getEndpoint(String cloudPath, String pluginPath) {
    return '$baseUrl$api';
  }

  // Authentication
  static String get signInUrl =>
      getEndpoint('auth/login', 'dokan-app/jwt-auth/token');
}
