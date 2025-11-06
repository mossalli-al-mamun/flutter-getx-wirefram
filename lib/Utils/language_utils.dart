import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Utility for resolving language display information from assets/languages.json
/// Fallbacks gracefully when codes aren't found.
class LanguageUtils {
  static Map<String, dynamic>? _cache; // code -> { name, native, rtl? }

  /// Ensure the language map is loaded and cached.
  static Future<void> ensureLoaded() async {
    if (_cache != null) return;
    final String jsonStr = await rootBundle.loadString('assets/languages.json');
    final Map<String, dynamic> map = json.decode(jsonStr) as Map<String, dynamic>;
    _cache = map;
  }

  static Map<String, dynamic>? _entry(String? code) {
    if (code == null || code.isEmpty) return null;
    final c = code.toLowerCase();
    final map = _cache;
    if (map == null) return null;
    final entry = map[c];
    if (entry is Map<String, dynamic>) return entry;
    return null;
  }

  /// Native name for the language code, e.g., "Español" for es.
  /// Falls back to the English name, and finally to the uppercased code.
  static String nativeNameFor(String? code) {
    final entry = _entry(code);
    if (entry != null) {
      final native = entry['native']?.toString();
      if (native != null && native.trim().isNotEmpty) return native;
      final name = entry['name']?.toString();
      if (name != null && name.trim().isNotEmpty) return name;
    }
    return (code ?? '').toUpperCase();
  }

  /// English name for the language code, e.g., "Spanish" for es.
  /// Falls back to native name, then uppercased code.
  static String englishNameFor(String? code) {
    final entry = _entry(code);
    if (entry != null) {
      final name = entry['name']?.toString();
      if (name != null && name.trim().isNotEmpty) return name;
      final native = entry['native']?.toString();
      if (native != null && native.trim().isNotEmpty) return native;
    }
    return (code ?? '').toUpperCase();
  }

  /// Whether the language is RTL per languages.json, default false.
  static bool isRtl(String? code) {
    final entry = _entry(code);
    if (entry == null) return false;
    final rtl = entry['rtl'];
    if (rtl is bool) return rtl;
    return false;
  }

  /// Shared display text resolver used across the app.
  /// Prefers the provided name in the model, then falls back to languages.json native name,
  /// and finally to the uppercased code if nothing else is available.
  static String displayTextFrom(dynamic lang) {
    final code = lang.code ?? '';
    final provided = lang.name;
    if (provided != null && provided.isNotEmpty) return provided;
    return nativeNameFor(code);
  }
}
