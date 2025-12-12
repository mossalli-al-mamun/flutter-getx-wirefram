import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../Widgets/app_scaffold.dart';
import '../../Widgets/headers/navigation_header.dart';
import '../../Controller/locale/localization_service_controller.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String? _version;
  String? _buildNumber;
  String? _appName;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _version = info.version;
        _buildNumber = info.buildNumber;
        _appName = info.appName;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final versionText = _version != null
        ? (_buildNumber != null ? '${_version!} (+$_buildNumber)' : _version!)
        : '—';

    return AppScaffold(
      scrollable: false,
      appBar: NavigationHeader(title: tr['about'], centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                // backgroundImage: AssetImage('assets/Images/appLogo.png'),
                // backgroundColor: Colors.transparent,
                child: Icon(Icons.info_outline_rounded),
              ),
              16.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _appName ?? tr['appName'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    4.height,
                    Text('${tr['version']}: $versionText', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              )
            ],
          ),
          16.height,
          Text(
            tr['aboutDescription1'],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          16.height,
          Text(
            tr['aboutDescription2'],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
