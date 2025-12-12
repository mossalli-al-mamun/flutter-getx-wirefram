import 'package:get/get.dart';

import '../../Utils/app_logger.dart';
import '../../Utils/local_storage_manager.dart';
import '../../Utils/permissionHelper/notification_permission_helper.dart';
import '../../Utils/settings/notification_preferences.dart';

/// SettingsController
/// - Owns notification preferences and weekend days
/// - Persists to NotificationPreferences (and legacy key for master toggle)
/// - Keeps state alive across tabs so toggles don't flicker/reset
class SettingsController extends GetxController {
  // Reactive state
  final isLoaded = false.obs;
  final masterEnabled = false.obs;
  final attendanceEnabled = true.obs;
  final announcementEnabled = true.obs;
  final birthdayEnabled = true.obs;
  final weekendDays = <int>[DateTime.saturday, DateTime.sunday].obs;

  // Clock style: 'rect' (rectangular), 'circle', or 'digital'
  final clockStyle = 'rect'.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      // Backward-compat for master toggle
      final legacy = LocalStorageManager.readData('push_notifications') as bool?;
      final master = await NotificationPreferences.isMasterEnabled();
      masterEnabled.value = legacy ?? master;

      attendanceEnabled.value = await NotificationPreferences.isAttendanceEnabled();
      announcementEnabled.value = await NotificationPreferences.isAnnouncementEnabled();
      birthdayEnabled.value = await NotificationPreferences.isBirthdayEnabled();
      weekendDays.assignAll(await NotificationPreferences.getWeekendDays());

      // Load clock style from local storage; default 'digital'
      final style = await LocalStorageManager.readData('clock_style');
      if (style is String && (style == 'rect' || style == 'circle' || style == 'digital')) {
        clockStyle.value = style;
      } else {
        clockStyle.value = 'circle';
      }
    } catch (e, st) {
      appLogger('SettingsController load error: $e\n$st');
    } finally {
      isLoaded.value = true;
    }
  }

  Future<void> toggleMaster(bool enabled) async {
    masterEnabled.value = enabled;
    await LocalStorageManager.saveData('push_notifications', enabled);
    await NotificationPreferences.setMasterEnabled(enabled);
    if (enabled) {
      // Request runtime permission where applicable (Android 13+)
      await requestNotificationsPermission();
    }
  }

  Future<void> setAttendance(bool enabled) async {
    attendanceEnabled.value = enabled;
    await NotificationPreferences.setAttendanceEnabled(enabled);
  }

  Future<void> setAnnouncement(bool enabled) async {
    announcementEnabled.value = enabled;
    await NotificationPreferences.setAnnouncementEnabled(enabled);
  }

  Future<void> setBirthday(bool enabled) async {
    birthdayEnabled.value = enabled;
    await NotificationPreferences.setBirthdayEnabled(enabled);
  }

  Future<void> addWeekend(int day) async {
    if (!weekendDays.contains(day)) {
      weekendDays.add(day);
      weekendDays.sort();
      await NotificationPreferences.setWeekendDays(weekendDays.toList());
    }
  }

  Future<void> removeWeekend(int day) async {
    weekendDays.remove(day);
    await NotificationPreferences.setWeekendDays(weekendDays.toList());
  }

  Future<void> setClockStyle(String style) async {
    if (style != 'rect' && style != 'circle' && style != 'digital') return;
    clockStyle.value = style;
    await LocalStorageManager.saveData('clock_style', style);
  }
}
