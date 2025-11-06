import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/local_storage_keys.dart';
import 'app_logger.dart';

class LocalStorageManager {
  static late SharedPreferences prefs;

  /// Initialize the SharedPreferences instance
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveData<T>(String key, T value) async {
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      appLogger("Invalid Type");
    }
  }

  static dynamic readData(String key) {
    dynamic obj = prefs.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    return prefs.remove(key);
  }

  static Future<void> clearAll() async {
    await prefs.clear();
  }

  /// Clears all stored data except for user preferences defined in StorageKeys.preferenceKeys
  static Future<void> clearAllExceptPreferences() async {
    return clearAllExcept(LocalStorageKeys.preferenceKeys);
  }

  /// Clears all stored data except for the specified keys
  static Future<void> clearAllExcept(List<String> keysToPreserve) async {
    // Save values for keys to preserve
    Map<String, String?> savedValues = {};
    for (String key in keysToPreserve) {
      savedValues[key] = readData(key);
    }

    // Clear all data
    await clearAll();

    // Restore preserved values
    for (String key in savedValues.keys) {
      if (savedValues[key] != null) {
        await saveData(key, savedValues[key]!);
      }
    }
  }
}
