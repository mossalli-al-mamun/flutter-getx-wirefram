import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_logger.dart';

class TokenManager {
  final _storage = const FlutterSecureStorage();
  final options =
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  String key = "userToken";

  /// Manage token by secure storage
  Future<String?> saveToken( String token) async {
    try {
      await _storage.write(key: key, value: token, iOptions: options);
    } catch (e) {
      appLogger('Error getting token: $e');
    }
    return null;
  }

  Future<String?> readToken() async {
    try {
      final String? token =
          await _storage.read(key: key, iOptions: options);
      return token;
    } catch (e) {
      appLogger('Error getting token: $e');
    }
    return null;
  }

  Future<String?> deleteToken() async {
    try {
      await _storage.delete(key: key, iOptions: options);
    } catch (e) {
      appLogger('Error getting token: $e');
    }
    return null;
  }

  ///Manage token by localStorage
  // static Future<String?> saveToken(token) async {
  //   try {
  //     LocalStorageManager.saveData('token', token);
  //   } catch (e) {
  //     appLogger('Error getting token: $e');
  //   }
  // }
  //
  // static Future<String?> readToken() async {
  //   try {
  //     final String? token = await LocalStorageManager.readData('token');
  //     return token;
  //   } catch (e) {
  //     appLogger('Error getting token: $e');
  //   }
  // }
}
