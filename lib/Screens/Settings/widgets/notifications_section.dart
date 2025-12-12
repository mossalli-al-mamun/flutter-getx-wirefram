import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:get/get.dart';
import '../../../Controller/settings/settings_controller.dart';
import 'settings_list_tile.dart';
import 'toggle_row.dart';
import '../../../Controller/locale/localization_service_controller.dart';

class NotificationsSection extends StatelessWidget {
  NotificationsSection({super.key});
  final _settings = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsListTile(
            icon: Icons.notifications_active_rounded,
            title: tr.notifications,
            trailing: Switch.adaptive(
              value: _settings.masterEnabled.value,
              onChanged: (v) => _settings.toggleMaster(v),
              activeTrackColor: context.primary,
            ),
            onTap: () => _settings.toggleMaster(!_settings.masterEnabled.value),
          ),
          if (_settings.masterEnabled.value) ...[
            Padding(
              // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.fromLTRB(35, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ToggleRow(
                    icon: Icons.timelapse_rounded,
                    title: tr['schedule'],
                    value: _settings.attendanceEnabled.value,
                    onChanged: (v) async => _settings.setAttendance(v),
                  ),
                  8.height,
                  ToggleRow(
                    icon: Icons.campaign_rounded,
                    title: tr['announcements'],
                    value: _settings.announcementEnabled.value,
                    onChanged: (v) async => _settings.setAnnouncement(v),
                  ),
                  8.height,
                  ToggleRow(
                    icon: Icons.cake_rounded,
                    title: tr['birthday'],
                    value: _settings.birthdayEnabled.value,
                    onChanged: (v) async => _settings.setBirthday(v),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }
}
