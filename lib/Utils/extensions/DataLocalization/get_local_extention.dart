import 'package:get/get.dart';

extension GetLocaleExtension on Never {
  /// Gets the current language code (e.g., 'en', 'es'). Defaults to 'en'.
  static String getLangCode() {
    final locale = Get.locale; // GetX global locale
    return locale?.languageCode ?? 'en';
  }
}