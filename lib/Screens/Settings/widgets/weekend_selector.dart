import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'weekend_chip.dart';
import '../../../Controller/locale/localization_service_controller.dart';

/// Composite widget that renders selected weekend chips and available day chips
/// to add. Stateless; consumers provide the current weekendDays and callbacks.
class WeekendSelector extends StatelessWidget {
  final List<int> weekendDays; // 1..7
  final ValueChanged<int> onAddDay;
  final ValueChanged<int> onRemoveDay;

  const WeekendSelector({
    super.key,
    required this.weekendDays,
    required this.onAddDay,
    required this.onRemoveDay,
  });

  static const List<int> _availableDays = <int>[
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  String _weekdayLabel(int weekday) {
    switch (weekday) {
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
        return '${tr['day']} $weekday';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected weekend chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: weekendDays
              .map((d) => WeekendChip(
                    day: d,
                    onRemove: () => onRemoveDay(d),
                  ))
              .toList(),
        ),
        8.height,
        // Available days to add
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableDays
              .where((d) => !weekendDays.contains(d))
              .map((d) => ActionChip(
                    label: Text(_weekdayLabel(d)),
                    onPressed: () => onAddDay(d),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
