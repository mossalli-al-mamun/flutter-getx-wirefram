import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_x;
import 'package:get/get_core/src/get_main.dart';

import '../Screens/Auth/signin.dart';
import 'app_logger.dart';
import 'local_storage_manager.dart';
import 'token_manager.dart';

class DioInterceptors extends Interceptor {
  String? token = '';

  // Guard to prevent double navigation to SignIn on multiple concurrent 401/403 responses
  static bool _isRedirecting = false;
  static DateTime? _lastRedirectAt;
  static const Duration _redirectCooldown = Duration(seconds: 2);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    appLogger('REQUEST[${options.method}] => PATH: ${options.path}');

    token = await TokenManager().readToken();
    final userdata = LocalStorageManager.readData('userData');

    ///Auth token
    var validOtpToken = LocalStorageManager.readData('validOtpToken');

    /// OTP validation token
    validOtpToken = validOtpToken != null ? jsonDecode(validOtpToken) : '';

    if (userdata == null) {
      token = validOtpToken;
    }
    token ??= validOtpToken;

    // Resolve current language code
    final savedLocale = LocalStorageManager.readData('locale');
    final String langCode = (get_x.Get.locale?.languageCode ?? (savedLocale is String ? savedLocale : null) ?? 'en').toString();
    // Skip token for login (or any unauthenticated endpoint)
    final isLoginEndpoint =
        options.path.contains('/jwt-auth/v1/token') ||
            options.path.contains('/wp-json/jwt-auth/v1/token');

    if (!isLoginEndpoint) {
      // Only add token if not login request
      token = await TokenManager().readToken();
      if (token?.isNotEmpty == true) {
        options.headers["authorization"] = 'Bearer $token';
      }
    }

    options.queryParameters["locale"] = langCode;

    appLogger('REQUEST[${options.method}] => PATH: ${options.uri}');


    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    appLogger(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      final now = DateTime.now();
      if (_isRedirecting && _lastRedirectAt != null && now.difference(_lastRedirectAt!) < _redirectCooldown) {
        appLogger('Auth error received but redirect already in progress. Skipping duplicate navigation.');
        return super.onError(err, handler);
      }
      _isRedirecting = true;
      _lastRedirectAt = now;

      // Clear auth artifacts
      await TokenManager().deleteToken();

      // Navigate to the login page if unauthorized/forbidden
      Get.offAll(const SignIn());

      // Reset redirect guard after short cooldown to allow future legitimate redirects
      Future.delayed(_redirectCooldown, () => _isRedirecting = false);
    }
    appLogger(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
