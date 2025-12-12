import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../Models/calender/event_item.dart';
import '../app_logger.dart';
import 'timezone_initializer.dart';
import 'permission_and_channel.dart';
import 'time_parsing.dart';
import 'schedule_strategies.dart';
import '../local_storage_manager.dart';
import '../settings/notification_preferences.dart';

class SavedTimes {
  final String? start;
  final String? end;
  final int? savedAt; // epoch ms
  const SavedTimes({this.start, this.end, this.savedAt});
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const String _channelId = 'attendance_channel';
  static const String _channelName = 'Attendance Reminders';
  static const String _channelDesc = 'Reminders to check in and check out.';

  static Future<void> init() async {
    if (_initialized) return;

    await TimezoneInitializer.ensureInitialized();

    // Platform-specific initialization, permissions and channel setup
    final pac = PermissionAndChannel(_plugin);
    await pac.initializePlatforms();

    // Platform init complete
    _initialized = true;
  }

  /// Cancel existing attendance reminders before scheduling fresh ones.
  static Future<void> cancelAttendanceReminders() async {
    // Use fixed IDs for the two reminders.
    await _plugin.cancel(_IDS.checkInId);
    await _plugin.cancel(_IDS.checkOutId);
  }

  /// Schedules local notifications for check-in and check-out, based on
  /// the attendance [model]. If the scheduled time is in the past, it is skipped.
  static Future<void> scheduleAReminders(
    dynamic model, {
    List<EventItem>? events,
    bool scheduleIn = true,
    bool scheduleOut = true,
    CheckoutScheduleMode checkoutMode = CheckoutScheduleMode.likeScheduleIn,
  }) async {
    if (!_initialized) await init();

    // Respect user preferences
    final masterEnabled = await NotificationPreferences.isMasterEnabled();
    final attendanceEnabled =
        await NotificationPreferences.isAttendanceEnabled();
    if (!masterEnabled || !attendanceEnabled) {
      appLogger(
        'Notifications disabled by preferences (master=$masterEnabled, attendance=$attendanceEnabled). Canceling existing and skipping.',
      );
      await cancelAttendanceReminders();
      return;
    }
    final weekendDays = await NotificationPreferences.getWeekendDays();

    // Debug logging
    appLogger('=== Scheduling Notifications ===');
    appLogger('Weekend days: $weekendDays');
    appLogger('Full model.log: ${model.log}');

    // Try multiple possible time sources with persistence fallback for up to 30 days
    String? checkInTime = model.log.startTime;
    String? checkOutTime = model.log.endTime;

    // Load previously saved times if current ones are null/invalid
    final SavedTimes saved = await _readSavedTimes();
    bool isValid(String? v) =>
        v != null && v.trim().isNotEmpty && v != '00:00:00';

    // If model provides valid times, persist them; otherwise use saved if not expired
    if (isValid(checkInTime) || isValid(checkOutTime)) {
      await _persistTimes(
        start: isValid(checkInTime) ? checkInTime : saved.start,
        end: isValid(checkOutTime) ? checkOutTime : saved.end,
      );
    } else {
      // Only use saved if within 30 days
      final nowEpoch = DateTime.now().millisecondsSinceEpoch;
      const maxAgeMs = 30 * 24 * 60 * 60 * 1000; // 30 days
      if (saved.savedAt != null && (nowEpoch - saved.savedAt!) <= maxAgeMs) {
        checkInTime = saved.start ?? checkInTime;
        checkOutTime = saved.end ?? checkOutTime;
      }
    }

    appLogger('Using checkInTime: $checkInTime');
    appLogger('Using checkOutTime: $checkOutTime');

    // Build base times from start_time/end_time on the same (local) day.
    DateTime? baseCheckIn = combineWithToday(checkInTime);
    DateTime? baseCheckOut = combineWithToday(checkOutTime);

    appLogger('baseCheckIn: $baseCheckIn');
    appLogger('baseCheckOut: $baseCheckOut');

    if (baseCheckIn == null && scheduleIn) {
      appLogger(
        'WARNING: Cannot schedule check-in - startTime is null or invalid',
      );
    }
    if (baseCheckOut == null && scheduleOut) {
      appLogger(
        'WARNING: Cannot schedule check-out - endTime is null or invalid',
      );
    }

    final now = DateTime.now();
    appLogger('Current time: $now');

    const details = PermissionAndChannel.details;

    // Compute next valid check-in time if requested via strategy (delegated)
    final DateTime? scheduledCheckIn = await _scheduleCheckIn(
      now: now,
      details: details,
      scheduleCheckIn: scheduleIn,
      baseCheckIn: baseCheckIn,
      events: events ?? const [],
      weekendDays: weekendDays,
    );

    // Compute checkout time using selected strategy (delegated)
    final DateTime? scheduledCheckOut = await _scheduleCheckOut(
      now: now,
      details: details,
      scheduleCheckOut: scheduleOut,
      baseCheckOut: baseCheckOut,
      events: events ?? const [],
      weekendDays: weekendDays,
      checkoutMode: checkoutMode,
      referenceCheckIn: scheduledCheckIn,
    );

    if (kDebugMode) {
      // ignore: avoid_print
      print(
        'LocalNotificationService: scheduled check-in at ${scheduledCheckIn?.toString() ?? 'null'}, check-out at ${scheduledCheckOut?.toString() ?? 'null'}',
      );
    }
  }

  // Schedules check-in notification and returns the scheduled DateTime (wall clock) if set.
  static Future<DateTime?> _scheduleCheckIn({
    required DateTime now,
    required NotificationDetails details,
    required bool scheduleCheckIn,
    required DateTime? baseCheckIn,
    required List<EventItem> events,
    required List<int> weekendDays,
  }) async {
    DateTime? scheduledCheckIn;
    if (scheduleCheckIn && baseCheckIn != null) {
      scheduledCheckIn = computeNextCheckIn(
        now: now,
        baseCheckInToday: baseCheckIn,
        events: events,
        weekendDays: weekendDays,
      );
      if (scheduledCheckIn != null && scheduledCheckIn.isAfter(now)) {
        final tzTime = tz.TZDateTime.from(scheduledCheckIn, tz.local);
        appLogger('Scheduling check-in notification for: $tzTime');
        await _plugin.zonedSchedule(
          _IDS.checkInId,
          'In reminder',
          'Out reminder',
          tzTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
        appLogger('Check-in notification scheduled successfully');
      } else {
        appLogger('Check-in time is not in future or null, skipping');
        scheduledCheckIn = null;
      }
    } else {
      appLogger(
        'Check-in scheduling skipped: scheduleCheckIn=$scheduleCheckIn, baseCheckIn=$baseCheckIn',
      );
    }
    return scheduledCheckIn;
  }

  // Schedules check-out notification and returns the scheduled DateTime (wall clock) if set.
  static Future<DateTime?> _scheduleCheckOut({
    required DateTime now,
    required NotificationDetails details,
    required bool scheduleCheckOut,
    required DateTime? baseCheckOut,
    required List<EventItem> events,
    required List<int> weekendDays,
    required CheckoutScheduleMode checkoutMode,
    DateTime? referenceCheckIn,
  }) async {
    DateTime? scheduledCheckOut;
    if (scheduleCheckOut && baseCheckOut != null) {
      scheduledCheckOut = computeNextCheckOut(
        now: now,
        baseCheckOutToday: baseCheckOut,
        events: events,
        weekendDays: weekendDays,
        mode: checkoutMode,
        referenceCheckIn: referenceCheckIn,
      );
      if (scheduledCheckOut != null && scheduledCheckOut.isAfter(now)) {
        final tzTime = tz.TZDateTime.from(scheduledCheckOut, tz.local);
        appLogger('Scheduling check-out notification for: $tzTime');
        await _plugin.zonedSchedule(
          _IDS.checkOutId,
          'In reminder',
          'out reminder',
          tzTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
        appLogger('Check-out notification scheduled successfully');
      } else {
        appLogger('Check-out time not scheduled (null or not in future)');
        scheduledCheckOut = null;
      }
    } else {
      appLogger(
        'Check-out scheduling skipped: scheduleCheckOut=$scheduleCheckOut, baseCheckOut=$baseCheckOut',
      );
    }
    return scheduledCheckOut;
  }

  // Persist and restore last known start/end times for up to 30 days
  static const _kStartKey = 'attendance_start_time';
  static const _kEndKey = 'attendance_end_time';
  static const _kSavedAtKey = 'attendance_time_saved_at'; // epoch ms

  static Future<void> _persistTimes({String? start, String? end}) async {
    try {
      if (start != null && start.trim().isNotEmpty) {
        await LocalStorageManager.saveData(_kStartKey, start.trim());
      }
      if (end != null && end.trim().isNotEmpty) {
        await LocalStorageManager.saveData(_kEndKey, end.trim());
      }
      await LocalStorageManager.saveData(
        _kSavedAtKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      appLogger('Persist times error: $e');
    }
  }

  static Future<SavedTimes> _readSavedTimes() async {
    try {
      final start = await LocalStorageManager.readData(_kStartKey) as String?;
      final end = await LocalStorageManager.readData(_kEndKey) as String?;
      final savedAt = await LocalStorageManager.readData(_kSavedAtKey);
      int? when;
      if (savedAt is int) {
        when = savedAt;
      } else if (savedAt is String) {
        when = int.tryParse(savedAt);
      }
      return SavedTimes(start: start, end: end, savedAt: when);
    } catch (e) {
      appLogger('Read saved times error: $e');
      return const SavedTimes();
    }
  }

  static Future<void> showNowTest() async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      9999,
      'Immediate Test Notification',
      'This should appear right now!',
      details,
    );
  }
}

class _IDS {
  static const int checkInId = 10001;
  static const int checkOutId = 10002;
}
