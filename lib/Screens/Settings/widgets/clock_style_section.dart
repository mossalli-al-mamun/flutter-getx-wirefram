import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:get/get.dart';
import '../../../Controller/locale/localization_service_controller.dart';
import '../../../Controller/settings/settings_controller.dart';
import 'settings_section_header.dart';
import 'theme_selector_card.dart';

class ClockStyleSection extends StatelessWidget {
  ClockStyleSection({super.key});

  final _settings = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final style = _settings.clockStyle.value; // 'rect' | 'circle' | 'digital'
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsSectionHeader(title: tr['clockStyle']),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: ThemeSelectorCard(
                    label: tr['rectangular'],
                    icon: Icons.watch_rounded,
                    isSelected: style == 'rect',
                    onTap: () => _settings.setClockStyle('rect'),
                  ),
                ),
                12.width,
                Expanded(
                  child: ThemeSelectorCard(
                    label: tr['circular'],
                    icon: Icons.watch_later_rounded,
                    isSelected: style == 'circle',
                    onTap: () => _settings.setClockStyle('circle'),
                  ),
                ),
                12.width,
                Expanded(
                  child: ThemeSelectorCard(
                    label: tr['digital'],
                    icon: Icons.grid_3x3_rounded,
                    isSelected: style == 'digital',
                    onTap: () => _settings.setClockStyle('digital'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
