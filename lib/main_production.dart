import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Bindings/core_bindings.dart';
import 'Config/app_config.dart';
import 'Config/flavor.dart';
import 'Utils/local_storage_manager.dart';
import 'Utils/permissionHelper/notification_permission_helper.dart';
import 'app.dart';

Future<void> main() async {
  // Force production flavor when this entrypoint is used
  FlavorConfig.override(AppFlavor.production);

  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageManager.init();
  // await CurrencyHelper.initialize();

  // Inject all app-wide dependencies
  CoreBindings().dependencies();

  runApp(const MyApp());

  if (AppConfig.oneSignalAppID.isNotEmpty) {
    OneSignal.initialize(AppConfig.oneSignalAppID);
  }

  await requestNotificationsPermission();
}
