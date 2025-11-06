class ApiResponse<T> {
  final T? data;
  final String? message;
  final Map<String, dynamic>? errors;
  final int? statusCode;
  final bool isSuccess;
  final Map<String, List<String>>? headers;

  ApiResponse.success({
    this.data,
    this.message,
    this.statusCode,
    this.headers,
  })  : errors = null,
        isSuccess = true;

  ApiResponse.error({
    this.message,
    this.errors,
    this.statusCode,
    this.data,
    this.headers,
  }) : isSuccess = false;

  bool get hasData => data != null;

  bool get hasErrors => errors != null && errors!.isNotEmpty;

  bool get hasMessage => message != null && message!.isNotEmpty;

  String get formattedErrors {
    if (!hasErrors) return '';
    return errors!.entries
        .map((e) => '${e.key}: ${e.value.join(', ')}')
        .join('\n');
  }

  void when({
    required Function(T? data, String? message) onSuccess,
    required Function(
            String? message, Map<String, dynamic>? errors, int? statusCode)
        onError,
  }) {
    if (isSuccess) {
      onSuccess(data, message);
    } else {
      onError(message, errors, statusCode);
    }
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? fromJson,
  }) {
    if (json['status'] == 'success' || json['statusCode'] == 200) {
      return ApiResponse.success(
        data: fromJson != null && json['data'] != null
            ? fromJson(json['data'])
            : null,
        message: json['message'],
        statusCode: json['statusCode'],
      );
    } else {
      return ApiResponse.error(
        message: json['message'] ?? 'An error occurred',
        errors: json['errors'] is Map ? json['errors'] : null,
        statusCode: json['statusCode'],
        data: fromJson != null && json['data'] != null
            ? fromJson(json['data'])
            : null,
      );
    }
  }
}
