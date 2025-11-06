import 'flavor.dart';

class AppConfig {
  /// Set this to `true` for Production, `false` for Staging
  static const bool isProduction = false;

  // Base url
  static const String baseUrl = 'https://moucii.com';

  // OneSignal Configuration
  // Define per-flavor app IDs and expose a dynamic getter based on app flavor (from APP_FLAVOR)
  static const String _oneSignalAppIDProduction = '';
  static const String _oneSignalAppIDDevelopment = '';

  static String get oneSignalAppID {
    // Centralized via FlavorConfig
    switch (FlavorConfig.flavor) {
      case AppFlavor.production:
        return _oneSignalAppIDProduction;
      case AppFlavor.development:
        return _oneSignalAppIDDevelopment; // default to development if unspecified
    }
  }

  static const bool oneSignalDebugMode = false;
  static const bool requiresUserPrivacyConsent = true;

  // App Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;

  // Debug/Test Flags (do not enable in production)
  static const bool simulateError =
      false; // When true, Applied screen shows an artificial error

  // Singleton implementation
  // - The instance is created by calling the private constructor
  // - It's stored in memory for the entire application lifecycle
  // - `static` means this variable belongs to the class itself, not to instances
  // - `final` ensures it's initialized only once
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();
}
