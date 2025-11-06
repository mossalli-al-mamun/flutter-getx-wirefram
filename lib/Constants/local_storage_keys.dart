/// Centralized storage keys to use throughout the application
class LocalStorageKeys {
// User related keys
  static const String userData = 'userData';
  static const String token = 'token';
  static const String refreshToken = 'refreshToken';
  static const String isLoggedIn = 'isLoggedIn';
  static const String sessionToken = 'sessionToken';
  static const String userEmail = 'userEmail';

// App preferences
  static const String themeMode = 'themeMode';
  static const String generalSettings = 'generalSettings';
  static const String language = 'language';

// App state
  static const String onboardingComplete = 'onboardingComplete';
  static const String lastSync = 'lastSync';

// Collection of preference keys that should be preserved during logout/reset
  static List<String> get preferenceKeys => [
    themeMode,
    generalSettings,
    language,
  ];
}
