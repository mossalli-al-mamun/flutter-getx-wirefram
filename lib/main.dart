import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Bindings/core_bindings.dart';
import 'Config/app_config.dart';
import 'Config/flavor.dart';
import 'Utils/local_storage_manager.dart';
import 'Utils/permissionHelper/notification_permission_helper.dart';
import 'app.dart';

// Default production entrypoint
Future<void> main() async {
  // Force production flavor when running main.dart directly
  FlavorConfig.override(AppFlavor.production);

  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageManager.init();

  // Inject all app-wide dependencies
  CoreBindings().dependencies();

  runApp(const MyApp());

  if (AppConfig.oneSignalAppID.isNotEmpty) {
    OneSignal.initialize(AppConfig.oneSignalAppID);
  }

  await requestNotificationsPermission();
}
