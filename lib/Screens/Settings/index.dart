// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../Config/themes/theme_controller.dart';
// import '../../Controller/locale/locale_controller.dart';
// import '../../Controller/locale/localization_service_controller.dart';
// import '../../Utils/local_storage_manager.dart';
// import '../../Utils/permissionHelper/notification_permission_helper.dart';
// import '../../Config/themes/sizes.dart';
// import 'languages_list_screen.dart';
//
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key, this.cardBaseTheme = true});
//
//   final bool cardBaseTheme;
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   final ThemeController _themeController = Get.find();
//   final LocaleController _localeController = Get.find();
//
//   bool _pushEnabled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _pushEnabled = (LocalStorageManager.readData('push_notifications') as bool?) ?? false;
//   }
//
//   Future<void> _onPushToggle(bool value) async {
//     setState(() => _pushEnabled = value);
//     await LocalStorageManager.saveData('push_notifications', value);
//     if (value) {
//       await requestNotificationsPermission();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final themeMode = _themeController.themeMode.value;
//       final cs = Theme.of(context).colorScheme;
//       final langCode = _localeController.locale.value.languageCode;
//       String currentLangName;
//       switch (langCode) {
//         case 'ar':
//           currentLangName = tr.arabic;
//           break;
//         case 'es':
//           currentLangName = tr.spanish;
//           break;
//         case 'en':
//         default:
//           currentLangName = tr.english;
//       }
//       return ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           ListTile(
//             leading: Icon(Icons.language, color: cs.primary),
//             title: Text(tr.language),
//             subtitle: Text(currentLangName),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () async {
//               await Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => const LanguagesListScreen()),
//               );
//               setState(() {}); // refresh subtitle
//             },
//           ),
//           const Divider(height: 1),
//           SwitchListTile.adaptive(
//             secondary: Icon(Icons.notifications_active, color: cs.primary),
//             title: Text(tr.notifications),
//             value: _pushEnabled,
//             onChanged: _onPushToggle,
//           ),
//           const Divider(height: 1),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//             child: Text(tr.theme, style: const TextStyle(fontWeight: FontWeight.w600)),
//           ),
//           if (widget.cardBaseTheme)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: _ThemeCard(
//                       label: tr.systemDefault,
//                       icon: Icons.brightness_auto,
//                       selected: themeMode == ThemeMode.system,
//                       onTap: () => _themeController.setThemeMode(ThemeMode.system),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _ThemeCard(
//                       label: tr.light,
//                       icon: Icons.light_mode,
//                       selected: themeMode == ThemeMode.light,
//                       onTap: () => _themeController.setThemeMode(ThemeMode.light),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _ThemeCard(
//                       label: tr.dark,
//                       icon: Icons.dark_mode,
//                       selected: themeMode == ThemeMode.dark,
//                       onTap: () => _themeController.setThemeMode(ThemeMode.dark),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           const SizedBox(height: 8),
//           RadioListTile<ThemeMode>(
//             secondary: Icon(Icons.brightness_auto, color: cs.primary),
//             title: Text(tr.systemDefault),
//             value: ThemeMode.system,
//             groupValue: themeMode,
//             onChanged: (m) => _themeController.setThemeMode(ThemeMode.system),
//           ),
//           RadioListTile<ThemeMode>(
//             secondary: Icon(Icons.light_mode, color: cs.primary),
//             title: Text(tr.light),
//             value: ThemeMode.light,
//             groupValue: themeMode,
//             onChanged: (m) => _themeController.setThemeMode(ThemeMode.light),
//           ),
//           RadioListTile<ThemeMode>(
//             secondary: Icon(Icons.dark_mode, color: cs.primary),
//             title: Text(tr.dark),
//             value: ThemeMode.dark,
//             groupValue: themeMode,
//             onChanged: (m) => _themeController.setThemeMode(ThemeMode.dark),
//           ),
//         ],
//       );
//     });
//   }
// }
//
//
// class _ThemeCard extends StatelessWidget {
//   const _ThemeCard({
//     required this.label,
//     required this.icon,
//     required this.selected,
//     required this.onTap,
//   });
//
//   final String label;
//   final IconData icon;
//   final bool selected;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final borderColor = selected ? cs.primary : cs.outlineVariant;
//     final bg = selected ? cs.primaryContainer : Theme.of(context).cardColor;
//     final iconColor = selected ? cs.primary : cs.onSurfaceVariant;
//
//     return Card(
//       color: bg,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: borderColor, width: selected ? 2 : 1),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, color: iconColor),
//               const SizedBox(height: 6),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Theme.of(context).textTheme.bodyMedium?.color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ============================================
// FILE: settings_screen.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:get/get.dart';

import '../../Config/themes/theme_controller.dart';
import '../../Controller/locale/locale_controller.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../../Utils/local_storage_manager.dart';
import '../../Utils/permissionHelper/notification_permission_helper.dart';

// import 'components/settings_section_header.dart';
// import 'components/settings_list_tile.dart';
// import 'components/theme_selector_card.dart';
import 'languages_list_screen.dart';
import 'widgets/settings_list_tile.dart';
import 'widgets/settings_section_header.dart';
import 'widgets/theme_selector_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ThemeController _themeController = Get.find();
  final LocaleController _localeController = Get.find();

  bool _pushEnabled = false;

  @override
  void initState() {
    super.initState();
    _pushEnabled =
        (LocalStorageManager.readData('push_notifications') as bool?) ?? false;
  }

  Future<void> _onPushToggle(bool value) async {
    setState(() => _pushEnabled = value);
    await LocalStorageManager.saveData('push_notifications', value);
    if (value) {
      await requestNotificationsPermission();
    }
  }

  String _getCurrentLanguageName(String langCode) {
    switch (langCode) {
      case 'ar':
        return tr.arabic;
      case 'es':
        return tr.spanish;
      case 'en':
      default:
        return tr.english;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeMode = _themeController.themeMode.value;
      final langCode = _localeController.locale.value.languageCode;
      final currentLangName = _getCurrentLanguageName(langCode);

      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Language Section
          SettingsListTile(
            icon: Icons.language_rounded,
            title: tr.language,
            subtitle: currentLangName,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LanguagesListScreen()),
              );
              setState(() {});
            },
          ),

          // Notifications Section
          SettingsListTile(
            icon: Icons.notifications_active_rounded,
            title: tr.notifications,
            trailing: Switch.adaptive(
              value: _pushEnabled,
              onChanged: _onPushToggle,
              activeTrackColor: context.primary,
            ),
            onTap: () => _onPushToggle(!_pushEnabled),
          ),

          16.height,

          // Theme Section
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
                    onTap: () =>
                        _themeController.setThemeMode(ThemeMode.system),
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
          16.height,
        ],
      );
    });
  }
}

