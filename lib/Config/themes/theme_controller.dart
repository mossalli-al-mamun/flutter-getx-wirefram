import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/local_storage_manager.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs; // Default to system theme

  @override
  void onInit() {
    super.onInit();
    _loadTheme(); // Load theme when app starts
  }

  Future<void> _loadTheme() async {
    String? savedTheme = LocalStorageManager.readData('themeMode'); // Read from LocalStorage

    switch (savedTheme) {
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      case 'light':
        themeMode.value = ThemeMode.light;
        break;
      case 'system':
      default:
        themeMode.value = ThemeMode.system; // Default to system
    }
    Get.changeThemeMode(themeMode.value); // Apply theme
  }

  Future<void> toggleTheme() async {
    if (themeMode.value == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  Future<void> setThemeByKey(String key) async {
    switch (key) {
      case 'dark':
        await setThemeMode(ThemeMode.dark);
        break;
      case 'light':
        await setThemeMode(ThemeMode.light);
        break;
      case 'system':
      default:
        await setThemeMode(ThemeMode.system);
        break;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    final key = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.light
            ? 'light'
            : 'system';
    await LocalStorageManager.saveData('themeMode', key);
    Get.changeThemeMode(mode); // Apply theme
    update();
  }
}
