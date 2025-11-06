import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../app_logger.dart';
import '../local_storage_manager.dart';

Future<void> requestNotificationsPermission() async {
  try {
    // Check if we've already asked for permission before
    final hasPromptedForPermission =
        await LocalStorageManager.readData('has_prompted_notification') ??
            false;

    if (!hasPromptedForPermission) {
      // Only request permission if we haven't asked before
      // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt
      final accepted = await OneSignal.Notifications.requestPermission(true);

      // Save that we've prompted the user, regardless of their choice
      await LocalStorageManager.saveData('has_prompted_notification', true);

      // Save their choice
      await LocalStorageManager.saveData('push_notifications', accepted);

      appLogger("User accepted notifications: $accepted");
    }

    // Set up notification handlers
    OneSignal.Notifications.addClickListener((event) {
      appLogger("Clicked notification: ${event.notification.additionalData}");
      // Handle notification click
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      // Handle foreground notification
      event.notification.display();
    });
  } catch (e) {
    appLogger("Error setting up notifications: $e");
  }
}