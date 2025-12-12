import 'package:flutter/material.dart';

class WeekendChip extends StatelessWidget {
  final int day; // DateTime.weekday number 1..7
  final VoidCallback onRemove;
  const WeekendChip({super.key, required this.day, required this.onRemove});

  String _weekdayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '$weekday';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(_weekdayShort(day)),
      onDeleted: onRemove,
      deleteIcon: const Icon(Icons.close, size: 16),
    );
  }
}
