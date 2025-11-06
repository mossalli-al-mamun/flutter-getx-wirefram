import 'dart:io';

import 'package:dio/dio.dart';

import '../Utils/app_logger.dart';
import '../Utils/dio_interceptor.dart';
import 'api_response.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 60);
    // Initialize with other custom interceptor
    _dio.interceptors.add(DioInterceptors());
    // Add other interceptors if needed
  }

  // List of status codes that should be considered successful
  static const List<int> successStatusCodes = [
    200, // OK
    201, // Created
    202, // Accepted
    204, // No Content
    206, // Partial Content
  ];

  Future<ApiResponse<T>> _request<T>({
    required String method,
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    T Function(dynamic)? fromJson,
    T Function(dynamic, Map<String, String>?)? fromJsonWithHeaders,
  }) async {
    try {
      // Create base options
      final requestOptions = Options(
        method: method,
        headers: headers,
      );

      // Merge with provided options if they exist
      if (options != null) {
        requestOptions
          ..extra = options.extra ?? {}
          ..headers = {...?requestOptions.headers, ...?options.headers}
          ..responseType = options.responseType
          ..contentType = options.contentType
          ..validateStatus = options.validateStatus
          ..receiveDataWhenStatusError = options.receiveDataWhenStatusError
          ..followRedirects = options.followRedirects
          ..maxRedirects = options.maxRedirects
          ..requestEncoder = options.requestEncoder
          ..responseDecoder = options.responseDecoder;
      }
      final response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
      );

      // Extract headers
      final responseHeaders = response.headers.map;

      if (successStatusCodes.contains(response.statusCode)) {
        if (fromJson != null && response.data != null) {
          return ApiResponse.success(
              data: fromJson(response.data),
              message: _getMessageFromResponse(response.data),
              statusCode: response.statusCode,
              headers: responseHeaders);
        }
        Map<String, String> convertHeaders(Map<String, List<String>> headers) {
          return headers.map((key, value) => MapEntry(key, value.join(', ')));
        }

        if (fromJsonWithHeaders != null && response.data != null) {
          return ApiResponse.success(
              data: fromJsonWithHeaders(response.data, convertHeaders(responseHeaders)),
              message: _getMessageFromResponse(response.data),
              statusCode: response.statusCode,
              headers: responseHeaders);
        }
        return ApiResponse.success(
            statusCode: response.statusCode, message: _getMessageFromResponse(response.data));
      }

      final errorMessage = _getErrorMessage(response);
      final errorDetails = _getErrorDetails(response);
      appLogger(
          'API Warning - Method: $method, URL: $url, Status: ${response.statusCode}, Message: $errorMessage');
      return ApiResponse.error(
          message: errorMessage,
          statusCode: response.statusCode,
          errors: errorDetails,
          headers: responseHeaders,
          data: fromJson != null && response.data != null
              ? fromJson(response.data)
              : null);
    } on DioException catch (e) {
      final errorMessage = _getDioErrorMessage(e);
      final errorDetails = _getDioErrorDetails(e);
      appLogger(
          'API Exception - Method: $method, URL: $url, Error: $errorMessage, ErrorDetails: $errorDetails');
      return ApiResponse.error(
          message: errorMessage,
          statusCode: e.response?.statusCode,
          errors: errorDetails);
    }
  }

  String? _getMessageFromResponse(dynamic responseData) {
    if (responseData is Map) {
      return responseData['message']?.toString();
    }
    return null;
  }

  String _getErrorMessage(Response response) {
    try {
      if (response.data is Map) {
        return response.data['message'] ??
            response.data['error'] ??
            '${response.statusMessage}! Request failed with status ${response.statusCode}';
      }
      return '${response.statusMessage}! Request failed with status ${response.statusCode}';
    } catch (_) {
      return '${response.statusMessage}! Request failed with status ${response.statusCode}';
    }
  }

  Map<String, dynamic>? _getErrorDetails(Response response) {
    try {
      if (response.data is Map && response.data['errors'] is Map) {
        return response.data['errors'];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  String _getDioErrorMessage(DioException e) {
    if (e.response != null) {
      return _getErrorMessage(e.response!);
    }
    return e.message ?? 'Network error occurred';
  }

  Map<String, dynamic>? _getDioErrorDetails(DioException e) {
    if (e.response != null) {
      return _getErrorDetails(e.response!);
    }
    return null;
  }

  // GET
  Future<ApiResponse<T>> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    T Function(dynamic)? fromJson,
    T Function(dynamic, Map<String, String>?)? fromJsonWithHeaders,
  }) async {
    final updatedOptions = Options(
      headers: {
        ...?headers,
        'Accept': 'application/json',
      }
    );
    return _request(
        method: 'GET',
        url: url,
        queryParameters: queryParameters,
        headers: headers,
        options: updatedOptions,
        fromJson: fromJson,
        fromJsonWithHeaders: fromJsonWithHeaders);
  }

  // POST
  Future<ApiResponse<T>> post<T>({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    return _request(
      method: 'POST',
      url: url,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      fromJson: fromJson,
    );
  }

  // Helper function for file name extraction
  String extractFilename(String fullPath, {bool withExtension = true}) {
    String filename = fullPath.split('/').last;

    if (withExtension) {
      return filename;
    } else {
      return filename.split('.').first;
    }
  }

  // POST_FILE
  Future<ApiResponse<T>> postFile<T>({
    required String url,
    required File file,
    String? fileFieldName,
    String? filename,
    Map<String, dynamic>? formFields,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? fromJson,
  }) async {
    String defaultFileName =
        extractFilename(file.path).replaceFirst('image_picker_', '');
    // Create FormData
    final formData = FormData.fromMap({
      ...?formFields,
      fileFieldName ?? 'file': await MultipartFile.fromFile(
        file.path,
        filename: filename ?? defaultFileName,
      ),
    });

    // Set default options for file upload
    final uploadOptions = Options(
      contentType: 'multipart/form-data',
      headers: {
        ...?headers,
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
    );

    return await _request<T>(
      method: 'POST',
      url: url,
      data: formData,
      queryParameters: queryParameters,
      headers: headers,
      options: uploadOptions,
      fromJson: fromJson,
    );
  }

  // PUT
  Future<ApiResponse<T>> put<T>({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    return _request(
      method: 'PUT',
      url: url,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      fromJson: fromJson,
    );
  }

  // DELETE
  Future<ApiResponse<T>> delete<T>({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    return _request(
      method: 'DELETE',
      url: url,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      fromJson: fromJson,
    );
  }

  // PATCH
  Future<ApiResponse<T>> patch<T>({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    return _request(
      method: 'PATCH',
      url: url,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      fromJson: fromJson,
    );
  }
}
