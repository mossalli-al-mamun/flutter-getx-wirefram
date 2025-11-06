import 'package:flutter_getx_wireframe/Config/app_config.dart';

import '../Config/flavor.dart';

class BaseApi {
  static String? baseUrl = FlavorConfig.isProduction
      ? AppConfig.baseUrl
      : AppConfig.baseUrl;
  static String appFlavor = FlavorConfig.flavorString;

  static final String api = '/wp-json/';

  // Helper method to build endpoints
  static String getEndpoint(String endpoint) {
    return '$baseUrl$api$endpoint';
  }

  // Authentication
  static String get signInUrl => getEndpoint('jwt-auth/v1/token');


}
