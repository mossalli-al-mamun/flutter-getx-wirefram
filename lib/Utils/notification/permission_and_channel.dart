import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../app_logger.dart';

class PermissionAndChannel {
  final FlutterLocalNotificationsPlugin plugin;
  static const String channelId = 'attendance_channel';
  static const String channelName = 'Attendance Reminders';
  static const String channelDesc = 'Reminders to check in and check out.';

  const PermissionAndChannel(this.plugin);

  Future<void> initializePlatforms() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const macosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit, macOS: macosInit);

    await plugin.initialize(initSettings);

    // iOS/macOS permission
    await plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Android 13+ runtime permission
    final android = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    try {
      await android?.requestNotificationsPermission();
    } catch (_) {
      // ignore older devices
    }

    await android?.createNotificationChannel(const AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDesc,
      importance: Importance.high,
    ));

    appLogger('Notification channel ready: $channelId, $channelName');
  }

  static const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDesc,
    importance: Importance.high,
    priority: Priority.high,
  );

  static const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
  static const NotificationDetails details = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );
}
