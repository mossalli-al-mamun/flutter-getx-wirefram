import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:get/get.dart';
import '../../../Controller/locale/localization_service_controller.dart';
import '../../../Controller/settings/settings_controller.dart';
import 'settings_list_tile.dart';
import 'weekend_selector.dart';

class WeekendDaysTile extends StatefulWidget {
  const WeekendDaysTile({super.key});

  @override
  State<WeekendDaysTile> createState() => _WeekendDaysTileState();
}

class _WeekendDaysTileState extends State<WeekendDaysTile> {
  final _settings = Get.find<SettingsController>();
  bool _expanded = false;

  String _subtitleFor(List<int> days) {
    String name(int d) {
      switch (d) {
        case DateTime.monday:
          return tr['monday'];
        case DateTime.tuesday:
          return tr['tuesday'];
        case DateTime.wednesday:
          return tr['wednesday'];
        case DateTime.thursday:
          return tr['thursday'];
        case DateTime.friday:
          return tr['friday'];
        case DateTime.saturday:
          return tr['saturday'];
        case DateTime.sunday:
          return tr['sunday'];
        default:
          return '$d';
      }
    }

    final sorted = [...days]..sort();
    return sorted.map(name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final weekend = _settings.weekendDays.toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // const Divider(height: 1),
          SettingsListTile(
            icon: Icons.event_busy_rounded,
            title: tr['weekendDays'], 
            subtitle: _subtitleFor(weekend),
            trailing: Icon(
              _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
              color: context.onSurfaceVariant,
            ),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          AnimatedCrossFade(
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WeekendSelector(
                weekendDays: weekend,
                onAddDay: (d) async => _settings.addWeekend(d),
                onRemoveDay: (d) async => _settings.removeWeekend(d),
              ),
            ),
          ),
          8.height,
          // const Divider(height: 1),
        ],
      );
    });
  }
}
