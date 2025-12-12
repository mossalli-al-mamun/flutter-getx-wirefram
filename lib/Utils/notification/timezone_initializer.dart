import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../app_logger.dart';

/// Handles timezone database initialization and setting the local location.
class TimezoneInitializer {
  static bool _initialized = false;

  static Future<void> ensureInitialized({String fallback = 'Asia/Dhaka'}) async {
    if (_initialized) return;
    try {
      tz.initializeTimeZones();
      final dynamic tzInfo = await FlutterTimezone.getLocalTimezone();
      final String localTz = tzInfo is String ? tzInfo : (tzInfo.identifier as String);
      try {
        final location = tz.getLocation(localTz);
        tz.setLocalLocation(location);
      } catch (e) {
        appLogger('Invalid timezone: $localTz, falling back to $fallback');
        tz.setLocalLocation(tz.getLocation(fallback));
      }
    } catch (e) {
      appLogger('Timezone init failed: $e');
      tz.setLocalLocation(tz.getLocation(fallback));
    }
    _initialized = true;
  }
}
