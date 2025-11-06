import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../Utils/local_storage_manager.dart';
import '../../l10n/generated/app_localizations.dart';
import 'localization_service_controller.dart';

class LocaleController extends GetxController {
  Rx<Locale> locale = const Locale('en').obs; // Default to English

  @override
  void onInit() {
    super.onInit();
    loadLocale(); // Load saved locale on initialization
  }

  Future<void> _applyIntlLocale(Locale loc) async {
    // Try to initialize date formatting for the locale; fallback to English
    try {
      Intl.defaultLocale = loc.languageCode;
      await initializeDateFormatting(loc.languageCode);
    } catch (_) {
      Intl.defaultLocale = 'en';
      try { await initializeDateFormatting('en'); } catch (_) {}
    }
  }

  Future<void> loadLocale() async {
    String? savedLocale = LocalStorageManager.readData('locale'); // Read saved locale
    final Locale resolved = _resolveSupported(savedLocale);
    locale.value = resolved;
    await _applyIntlLocale(resolved);
    Get.updateLocale(locale.value); // Apply the locale
    // Ensure dynamic localization service (loc[...]) matches current locale
    await initializeLocalizationService(resolved);
  }

  Future<void> changeLocale(String languageCode) async {
    final Locale resolved = _resolveSupported(languageCode);
    locale.value = resolved; // Update locale
    await LocalStorageManager.saveData('locale', resolved.languageCode); // Save to local storage
    await _applyIntlLocale(resolved);
    Get.updateLocale(locale.value); // Apply the new locale
    // Keep dynamic localization service in sync for loc['...'] accessors
    await initializeLocalizationService(resolved);
  }

  // Ensure we only use supported locales; fallback to English
  Locale _resolveSupported(String? code) {
    final String c = (code == null || code.isEmpty) ? 'en' : code;
    final supported = AppLocalizations.supportedLocales.map((e) => e.languageCode).toSet();
    final lc = c.toLowerCase();
    if (supported.contains(lc)) return Locale(lc);
    return const Locale('en');
  }
}


