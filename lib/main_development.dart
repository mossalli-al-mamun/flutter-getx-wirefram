import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Bindings/core_bindings.dart';
import 'Config/app_config.dart';
import 'Config/flavor.dart';
import 'Utils/local_storage_manager.dart';
import 'Utils/permissionHelper/notification_permission_helper.dart';
import 'app.dart';

Future<void> main() async {
  // Force development flavor when this entrypoint is used
  FlavorConfig.override(AppFlavor.development);

  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageManager.init();
  // await CurrencyHelper.initialize();

  // Inject all app-wide dependencies
  CoreBindings().dependencies();

  runApp(const MyApp());

  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(AppConfig.oneSignalAppID);

  await requestNotificationsPermission();
}
