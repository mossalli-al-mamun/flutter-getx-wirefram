/// Centralized storage keys to use throughout the application
class LocalStorageKeys {
  // User related keys
  static const String userData = 'userData';
  static const String token = 'token';
  static const String refreshToken = 'refreshToken';
  static const String isLoggedIn = 'isLoggedIn';

  // App preferences
  static const String themeMode = 'themeMode';
  static const String generalSettings = 'generalSettings';
  static const String language = 'language';

  // App state
  static const String onboardingComplete = 'onboardingComplete';
  static const String lastSync = 'lastSync';
  static const String keepMeSignedIn = 'keepMeSignedIn';

  // Biometric auth
  // SharedPreferences flag indicating whether biometric login is enabled
  static const String biometricEnabled = 'biometric_enabled';
  // One-time prompt gate to avoid nagging users too often
  static const String biometricPrompted = 'biometric_prompted';
  // Keys for secure storage (Keychain/Keystore)
  static const String biometricEmail = 'biometric_email';
  static const String biometricPassword = 'biometric_password';

  // Collection of preference keys that should be preserved during logout/reset
  static List<String> get preferenceKeys => [
    themeMode,
    generalSettings,
    language,
    biometricEnabled,
    biometricPrompted,
  ];
}
