import 'package:flutter/material.dart';
import 'settings_section_header.dart';
import 'settings_list_tile.dart';
import '../../../Controller/locale/localization_service_controller.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionHeader(title: tr['support']),
        SettingsListTile(
          icon: Icons.help_center_rounded,
          title: tr['helpCenter'],
        ),
        SettingsListTile(
          icon: Icons.mail_outline_rounded,
          title: tr['contactSupport'],
        ),
      ],
    );
  }
}
