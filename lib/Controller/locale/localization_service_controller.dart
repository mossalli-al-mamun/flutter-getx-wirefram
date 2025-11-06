import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../Utils/app_logger.dart';
import '../../app.dart'; // path to where navigatorKey is defined
import '../../l10n/generated/app_localizations.dart';

class LocalizationServiceController extends GetxController{
  final Map<String, String> _localizedStrings;
  final Locale _locale;

  LocalizationServiceController(this._localizedStrings, this._locale);

  static Future<LocalizationServiceController> load(Locale locale) async {
    try {
      String jsonString = await rootBundle.loadString('lib/l10n/intl_${locale.languageCode}.arb');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      Map<String, String> strings = {};
      jsonMap.forEach((key, value) {
        if (!key.startsWith('@')) {
          strings[key] = value.toString();
        }
      });

      return LocalizationServiceController(strings, locale);
    } catch (e) {
      // Fallback to English if the locale file doesn't exist
      appLogger('Warning: Could not load locale ${locale.languageCode}, falling back to English');
      return load(const Locale('en'));
    }
  }

  // Get localized string by key
  String getString(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Get localized string with fallback
  String getStringWithFallback(String key, String fallback) {
    return _localizedStrings[key] ?? fallback;
  }

  // Check if key exists
  bool hasKey(String key) {
    return _localizedStrings.containsKey(key);
  }

  // Get all available keys
  List<String> get availableKeys => _localizedStrings.keys.toList();

  // Get current locale
  Locale get locale => _locale;

  // Bracket operator for dynamic access
  String operator [](String key) => getString(key);

  // Get localized string with parameters (if you use placeholders)
  String getStringWithParams(String key, Map<String, String> params) {
    String text = getString(key);
    params.forEach((param, value) {
      text = text.replaceAll('{$param}', value);
    });
    return text;
  }
}

// Global service instance
LocalizationServiceController? _localizationService;

// Initialize the service
Future<void> initializeLocalizationService(Locale locale) async {
  _localizationService = await LocalizationServiceController.load(locale);
}

// Get the service instance
LocalizationServiceController get locService {
  if (_localizationService == null) {
    throw Exception('LocalizationService not initialized. Call initializeLocalizationService() first.');
  }
  return _localizationService!;
}

// Get the regular AppLocalizations (for static access)
AppLocalizations get tr {
  // Prefer Get.context (current route context), fallback to navigatorKey context
  final BuildContext? context = Get.context ?? navigatorKey.currentContext;
  if (context == null) {
    throw Exception('Localization context is null. Ensure MyApp is mounted and a route is active.');
  }
  return AppLocalizations.of(context);
}

// Extension to add dynamic access to regular AppLocalizations
extension DynamicAppLocalizations on AppLocalizations {
  String operator [](String key) => locService[key];
}
