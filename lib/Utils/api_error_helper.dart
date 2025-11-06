import '../Services/api_response.dart';

/// Extracts a user-friendly error message from an API response structure.
///
/// It supports two common patterns in backend responses:
/// 1) A top-level "message" string
/// 2) An "errors" map where keys can vary (e.g., paymentMethod, shipment, order)
///    and values can be a String or a List of Strings.
///
/// Priority:
/// - If an errors map contains any non-empty message(s), return the first one.
/// - Else if a top-level message exists, return it.
/// - Else return the provided fallback.
String extractApiErrorMessage({
  String? message,
  Map<String, dynamic>? errors,
  String fallback = 'Something went wrong',
}) {
  // Handle errors map: pick the first non-empty value (String or List<String>)
  if (errors != null && errors.isNotEmpty) {
    for (final entry in errors.entries) {
      final value = entry.value;
      if (value == null) continue;

      if (value is List) {
        // Convert list to list of non-empty strings
        final msgs = value
            .where((e) => e != null)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (msgs.isNotEmpty) {
          return msgs.join(', ');
        }
      } else {
        final text = value.toString().trim();
        if (text.isNotEmpty) {
          return text;
        }
      }
    }
  }

  // Fallback to top-level message if available
  if (message != null && message.trim().isNotEmpty) return message.trim();

  // Final fallback
  return fallback;
}

/// Convenience helper overload for ApiResponse
String extractApiErrorMessageFromResponse<T>(ApiResponse<T> response, {String fallback = 'Something went wrong'}) {
  return extractApiErrorMessage(
    message: response.message,
    errors: response.errors,
    fallback: fallback,
  );
}
