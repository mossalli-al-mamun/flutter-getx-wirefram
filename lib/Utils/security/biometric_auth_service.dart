import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Constants/local_storage_keys.dart';
import '../app_logger.dart';
import '../local_storage_manager.dart';

/// BiometricAuthService (pure logic)
/// - Owns the toggle state (biometricEnabled)
/// - Persists via SharedPreferences
/// - Stores credentials securely via flutter_secure_storage
/// - Exposes helpers to authenticate and read/save credentials
enum BiometryType { none, face, fingerprint, iris }

class BiometricAuthService extends GetxService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secure = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  final enabled = false.obs;

  Future<BiometricAuthService> init() async {
    final flag = LocalStorageManager.readData(LocalStorageKeys.biometricEnabled) as bool?;
    enabled.value = flag ?? false;
    return this;
  }

  Future<bool> canCheckBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (e) {
      appLogger('local_auth.canCheckBiometrics failed: $e');
      return false;
    }
  }

  Future<void> setBiometricEnabled(bool value) async {
    enabled.value = value;
    await LocalStorageManager.saveData(LocalStorageKeys.biometricEnabled, value);
    if (!value) {
      await clearCredentials();
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    await _secure.write(key: LocalStorageKeys.biometricEmail, value: email);
    await _secure.write(key: LocalStorageKeys.biometricPassword, value: password);
  }

  Future<void> clearCredentials() async {
    await _secure.delete(key: LocalStorageKeys.biometricEmail);
    await _secure.delete(key: LocalStorageKeys.biometricPassword);
  }

  Future<bool> hasStoredCredentials() async {
    final email = await _secure.read(key: LocalStorageKeys.biometricEmail);
    final pass = await _secure.read(key: LocalStorageKeys.biometricPassword);
    return (email != null && email.isNotEmpty && pass != null && pass.isNotEmpty);
  }

  Future<bool> authenticateWithBiometrics({String? reason}) async {
    // Deprecated: prefer authenticateBiometricOnly
    try {
      final can = await canCheckBiometrics();
      if (!can) return false;
      final ok = await _localAuth.authenticate(
        biometricOnly: true,
        localizedReason: reason ?? 'Authenticate to continue',
      );
      return ok;
    } catch (e) {
      appLogger('Biometric authenticate error: $e');
      return false;
    }
  }

  /// Central method: biometric-only auth (no PIN/pattern fallback)
  Future<bool> authenticateBiometricOnly({
    String? reason,
    bool stickyAuth = true,
    bool useErrorDialogs = true,
  }) async {
    try {
      final can = await canCheckBiometrics();
      if (!can) return false;
      final ok = await _localAuth.authenticate(
        localizedReason: reason ?? 'Authenticate to continue',
        biometricOnly: true,
      );
      return ok;
    } catch (e) {
      appLogger('Biometric authenticate (biometricOnly) error: $e');
      return false;
    }
  }

  /// Attempts a biometric auth; returns true if user authenticated.
  Future<bool> verifyBiometrics({String? reason}) async {
    return authenticateBiometricOnly(reason: reason);
  }

  /// Determine available primary biometry type on this device
  Future<BiometryType> getAvailableBiometry() async {
    try {
      final can = await canCheckBiometrics();
      if (!can) return BiometryType.none;
      final types = await _localAuth.getAvailableBiometrics();
      // Prefer face over other types when present (e.g., iPhone with Face ID)
      if (types.contains(BiometricType.face)) return BiometryType.face;
      if (types.contains(BiometricType.fingerprint)) return BiometryType.fingerprint;
      if (types.contains(BiometricType.iris)) return BiometryType.iris;
      // Android may report strong/weak without specifying the modality; treat as fingerprint for icon choice.
      if (types.contains(BiometricType.strong) || types.contains(BiometricType.weak)) {
        return BiometryType.fingerprint;
      }
      return BiometryType.none;
    } catch (e) {
      appLogger('getAvailableBiometry failed: $e');
      return BiometryType.none;
    }
  }

  Future<bool> isFaceSupported() async => (await getAvailableBiometry()) == BiometryType.face;
  Future<bool> isFingerprintSupported() async => (await getAvailableBiometry()) == BiometryType.fingerprint;

  /// Read stored credentials (email, password). Returns null if missing.
  Future<Map<String, String>?> getStoredCredentials() async {
    final email = await _secure.read(key: LocalStorageKeys.biometricEmail);
    final password = await _secure.read(key: LocalStorageKeys.biometricPassword);
    if (email == null || email.isEmpty || password == null || password.isEmpty) return null;
    return {'email': email, 'password': password};
  }

  /// Should we prompt the user to enable biometrics after a manual login?
  /// Returns true only once (and only if biometrics are supported), and marks the prompt as shown.
  Future<bool> shouldPromptEnableAfterLogin() async {
    final alreadyPrompted = LocalStorageManager.readData(LocalStorageKeys.biometricPrompted) as bool? ?? false;
    if (alreadyPrompted) return false;
    final supported = await canCheckBiometrics();
    if (!supported) return false;
    await LocalStorageManager.saveData(LocalStorageKeys.biometricPrompted, true);
    return true;
  }
}
