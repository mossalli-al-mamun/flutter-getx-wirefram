import 'dart:convert';

import '../local_storage_manager.dart';

/// Central place to store and retrieve notification/user scheduling preferences.
///
/// Weekend handling:
/// - Uses DateTime.weekday semantics: Monday=1 ... Sunday=7.
/// - Default weekends = Saturday(6), Sunday(7).
///
/// Notification toggles:
/// - master (global on/off)
/// - attendance reminders
/// - announcement
/// - birthday
class NotificationPreferences {
  static const _key = 'notification_prefs_v1';

  // Defaults
  static const List<int> _defaultWeekendDays = [6, 7];
  static const bool _defaultMaster = true;
  static const bool _defaultAttendance = true;
  static const bool _defaultAnnouncement = true;
  static const bool _defaultBirthday = true;

  static Future<Map<String, dynamic>> _readAll() async {
    final raw = await LocalStorageManager.readData(_key);
    if (raw is String && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return map;
      } catch (_) {}
    }
    return <String, dynamic>{};
  }

  static Future<void> _writeAll(Map<String, dynamic> map) async {
    await LocalStorageManager.saveData(_key, jsonEncode(map));
  }

  // Weekend days
  static Future<List<int>> getWeekendDays() async {
    final map = await _readAll();
    final list = map['weekendDays'];
    if (list is List) {
      final ints = list.map((e) => (e is int) ? e : int.tryParse('$e') ?? -1).where((e) => e >= 1 && e <= 7).toList();
      if (ints.isNotEmpty) return ints;
    }
    return _defaultWeekendDays;
  }

  static Future<void> setWeekendDays(List<int> days) async {
    final cleaned = days.where((d) => d >= 1 && d <= 7).toList()..sort();
    final map = await _readAll();
    map['weekendDays'] = cleaned;
    await _writeAll(map);
  }

  // Master notifications toggle
  static Future<bool> isMasterEnabled() async {
    final map = await _readAll();
    final v = map['masterEnabled'];
    return v is bool ? v : _defaultMaster;
  }

  static Future<void> setMasterEnabled(bool enabled) async {
    final map = await _readAll();
    map['masterEnabled'] = enabled;
    await _writeAll(map);
  }

  // Attendance reminders toggle
  static Future<bool> isAttendanceEnabled() async {
    final map = await _readAll();
    final v = map['attendanceEnabled'];
    return v is bool ? v : _defaultAttendance;
  }

  static Future<void> setAttendanceEnabled(bool enabled) async {
    final map = await _readAll();
    map['attendanceEnabled'] = enabled;
    await _writeAll(map);
  }

  // Announcement toggle
  static Future<bool> isAnnouncementEnabled() async {
    final map = await _readAll();
    final v = map['announcementEnabled'];
    return v is bool ? v : _defaultAnnouncement;
  }

  static Future<void> setAnnouncementEnabled(bool enabled) async {
    final map = await _readAll();
    map['announcementEnabled'] = enabled;
    await _writeAll(map);
  }

  // Birthday toggle
  static Future<bool> isBirthdayEnabled() async {
    final map = await _readAll();
    final v = map['birthdayEnabled'];
    return v is bool ? v : _defaultBirthday;
  }

  static Future<void> setBirthdayEnabled(bool enabled) async {
    final map = await _readAll();
    map['birthdayEnabled'] = enabled;
    await _writeAll(map);
  }
}
