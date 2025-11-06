import '../Controller/locale/localization_service_controller.dart';

/// Shared helpers to normalize arbitrary status/label strings into
/// localization keys and translate them safely.
class LabelTranslator {
  /// Normalize a raw label like:
  /// - "ready_to_run" -> "readyToRun"
  /// - "Ready To Run" -> "readyToRun"
  /// - "started" -> "started"
  /// - "Started" -> "started"
  static String normalizeKey(String? input) {
    if (input == null) return '';
    String s = input.trim();
    if (s.isEmpty) return '';

    // Replace multiple spaces with single underscore and lower-case
    s = s.replaceAll(RegExp(r"[-\s]+"), '_').toLowerCase();

    // Convert snake_case to camelCase
    final parts = s.split('_').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    final first = parts.first; // already lower
    final rest = parts
        .skip(1)
        .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
        .join();
    return first + rest;
  }

  /// Attempt to translate a label. If a custom translator is provided, it will
  /// be used first; otherwise, it falls back to tr['key'] using the normalized
  /// key produced by [normalizeKey]. If translation fails, returns the original
  /// label.
  static String maybeTranslate(String? label, {String Function(String)? translate}) {
    if (label == null || label.isEmpty) return '';

    final key = normalizeKey(label);

    // Prefer a provided translator (e.g., loc[...])
    if (translate != null) {
      try {
        final t = translate(key);
        if (t.isNotEmpty && t != key) return t;
      } catch (_) {}
    }

    // Fallback to global localization service
    try {
      final t = tr[key];
      if (t.isNotEmpty && t != key) return t;
    } catch (_) {}

    // As a last resort, return original label
    return label;
  }
}
