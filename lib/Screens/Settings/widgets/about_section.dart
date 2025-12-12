import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../about_screen.dart';
import 'settings_list_tile.dart';
import 'settings_section_header.dart';
import '../../../Controller/locale/localization_service_controller.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  String? _version;
  String? _buildNumber;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
    } catch (_) {
      // keep nulls; UI will show placeholder
    }
  }

  @override
  Widget build(BuildContext context) {
    final versionText = _version != null
        ? (_buildNumber != null ? '${_version!} (+$_buildNumber)' : _version!)
        : '—';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // SettingsListTile(
        //   icon: Icons.info_outline_rounded,
        //   title: 'About',
        //   onTap: () async {
        //     await Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (_) => const AboutScreen(),
        //       ),
        //     );
        //   },
        // ),
        SettingsSectionHeader(title: tr['about']),
        SettingsListTile(
          icon: Icons.info_outline_rounded,
          title: tr['version'],
          subtitle: versionText,
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AboutScreen(),
              ),
            );
          },
        ),
        8.height,
      ],
    );
  }
}
