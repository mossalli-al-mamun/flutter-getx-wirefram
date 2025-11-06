import 'package:get/get.dart';
import '../Utils/app_logger.dart';
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
    final response = await request();
    if (response.isSuccess) {
      return response;
    } else {
      onError?.call(response.message);
      appLogger('Error in {$request}: ${response.message}');
      throw '${response.message}';
    }
  }
}
