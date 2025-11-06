/// Centralized flavor configuration for the app.
///
/// This reads APP_FLAVOR once (production|development) and exposes
/// helpers for other modules. All flavor-specific branching should
/// depend on this file instead of reading environment variables directly
/// or overriding values in multiple places.
library;

enum AppFlavor { production, development }

class FlavorConfig {
  // Optional runtime override set by entrypoints (e.g., main_development.dart).
  static AppFlavor? _override;

  /// Call this early in main() to force a flavor without dart-define or CLI flags.
  static void override(AppFlavor flavor) {
    _override = flavor;
  }

  // Read once at compile-time from DART_DEFINES.
  static const String _envFlavorNew = String.fromEnvironment('APP_FLAVOR');

  // Backward-compatibility with previously used key.
  static const String _envFlavorOld = String.fromEnvironment('FLUTTER_APP_FLAVOR');
  static const String _envFlavor = _envFlavorNew == '' ? _envFlavorOld : _envFlavorNew;

  static AppFlavor get flavor {
    if (_override != null) return _override!;
    switch (_envFlavor.toLowerCase()) {
      case 'production':
        return AppFlavor.production;
      case 'development':
        return AppFlavor.development;
      default:
        return AppFlavor.development;
    }
  }

  static String get flavorString {
    switch (flavor) {
      case AppFlavor.production:
        return 'production';
      case AppFlavor.development:
        return 'development';
    }
  }

  static bool get isProduction => flavor == AppFlavor.production;

  static bool get isDevelopment => flavor == AppFlavor.development;
}
