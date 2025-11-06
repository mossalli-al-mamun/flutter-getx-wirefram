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

    options.headers["authorization"] = 'Bearer $token';
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
    if (err.response?.statusCode == 401) {
      await TokenManager().deleteToken();
      // Navigate to the login page if response is 401
      Get.offAll(const SignIn());
    }
    appLogger(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
