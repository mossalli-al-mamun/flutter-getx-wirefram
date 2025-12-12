import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:get/get.dart';
import '../../../Config/themes/theme_controller.dart';
import 'settings_section_header.dart';
import 'theme_selector_card.dart';
import '../../../Controller/locale/localization_service_controller.dart';

class ThemeSection extends StatelessWidget {
  ThemeSection({super.key});
  final _themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeMode = _themeController.themeMode.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsSectionHeader(title: tr.theme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: ThemeSelectorCard(
                    label: tr.systemDefault,
                    icon: Icons.brightness_auto_rounded,
                    isSelected: themeMode == ThemeMode.system,
                    onTap: () => _themeController.setThemeMode(ThemeMode.system),
                  ),
                ),
                12.width,
                Expanded(
                  child: ThemeSelectorCard(
                    label: tr.light,
                    icon: Icons.light_mode_rounded,
                    isSelected: themeMode == ThemeMode.light,
                    onTap: () => _themeController.setThemeMode(ThemeMode.light),
                  ),
                ),
                12.width,
                Expanded(
                  child: ThemeSelectorCard(
                    label: tr.dark,
                    icon: Icons.dark_mode_rounded,
                    isSelected: themeMode == ThemeMode.dark,
                    onTap: () => _themeController.setThemeMode(ThemeMode.dark),
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
