/// Utility for generating emoji flags from ISO country codes
/// and resolving a best-effort flag for a language setting.
class FlagUtils {
  /// Returns the emoji flag for a given ISO 3166-1 alpha-2 country code.
  /// If the provided code is invalid, returns an empty string.
  static String flagFromCountry(String? countryCode) {
    final cc = (countryCode ?? '').toUpperCase();

    // Fallback language → country map
    const Map<String, String> fallbackMap = {
      'EN': 'US', // English -> 🇺🇸
      'HI': 'IN', // Hindi -> 🇮🇳
      'BN': 'BD', // Bengali -> 🇧🇩
      'JA': 'JP', // Japanese -> 🇯🇵
      'KO': 'KR', // Korean -> 🇰🇷
      'FA': 'IR', // Persian -> 🇮🇷
      'UR': 'PK', // Urdu -> 🇵🇰
      'SV': 'SE', // Swedish -> 🇸🇪
      'DA': 'DK', // Danish -> 🇩🇰
      'EL': 'GR', // Greek -> 🇬🇷
      'CS': 'CZ', // Czech -> 🇨🇿
      'AR': 'SA', // Arabic -> 🇸🇦
    };

    final resolvedCountry = fallbackMap[cc] ?? cc;

    if (resolvedCountry.length != 2) return '';
    const int base = 0x1F1E6; // Regional Indicator Symbol Letter A
    return String.fromCharCode(base + (resolvedCountry.codeUnitAt(0) - 65)) +
        String.fromCharCode(base + (resolvedCountry.codeUnitAt(1) - 65));
  }

  /// Returns the emoji flag for a language by preferring the explicit country
  /// if provided; otherwise, falls back to the language code.
  static String flagForLanguage({String? country, String? code}) {
    final resolved = (country?.isNotEmpty ?? false) ? country : code;
    return flagFromCountry(resolved);
  }

  /// Convenience overload to accept a LanguageSetting directly.
  static String flagFor(dynamic lang) {
    return flagForLanguage(country: lang.country, code: lang.code);
  }
}
