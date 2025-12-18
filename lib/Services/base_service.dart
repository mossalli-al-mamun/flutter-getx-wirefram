import 'package:get/get.dart';
import '../Utils/app_logger.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'api_service.dart';

abstract class BaseService {
  final ApiService _apiService;

  BaseService() : _apiService = Get.find<ApiService>();

  ApiService get apiService => _apiService;

  Future<ApiResponse<T>> safeRequestHandler<T>(
      Future<ApiResponse<T>> Function() request, {
        void Function(String? message)? onError,
      }) async {
    try {
      final response = await request();
      if (response.isSuccess) {
        return response;
      } else {
        final message = response.message ?? 'An error occurred';
        onError?.call(response.message);
        appLogger('Error in {$request}: ${response.message}');
        throw ApiException(
          message: message,
          errors: response.errors,
          statusCode: response.statusCode,
        );
      }
    } catch (e, st) {
      onError?.call(e.toString());
      appLogger('Error in {$request}: $e, $st');
      if (e is ApiException) rethrow; // keep structured
      throw ApiException(message: e.toString());
    }
  }
}
