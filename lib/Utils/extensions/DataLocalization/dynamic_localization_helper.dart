import 'get_local_extention.dart';

extension DynamicDataLocalization on dynamic {
  String? getLocalizedString(dynamic value) => getLocalizedValue(value);

  /// Helper to resolve localized strings (reusable for title/description).
  String? getLocalizedValue(dynamic value) {
    if (value == null) return null;

    // Handle non-localized strings (e.g., "title": "Best Keyboard").
    if (value is String) return value;

    // Handle localized maps (e.g., "title": {"en": "Keyboard", "es": "Teclado"}).
    if (value is Map<String, dynamic>) {
      final langCode = GetLocaleExtension.getLangCode(); // Uses Get.locale
      return value[langCode]?.toString() ?? value['en']?.toString();
    }

    // Handle localized List<Map> (e.g., [{"id": 1, "name": "Keyboard"}, ...])
    if (value is List<dynamic>) {
      final firstItem = value.firstWhere(
        (item) => item is Map<String, dynamic>,
        orElse: () => null,
      );

      // Extract 'name' or localized field (e.g., 'name_en')
      if (firstItem != null) {
        final langCode = GetLocaleExtension.getLangCode();
        return firstItem['name_$langCode'] ?? firstItem['name']?.toString();
      }
    }

    return value.toString();
  }
}
