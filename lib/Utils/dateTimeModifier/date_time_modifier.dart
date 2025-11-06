import 'package:intl/intl.dart';

class DateTimeModifier {
  DateTime today = DateTime.now();

  DateTime getCurrentHour() {
    DateTime currentHour =
        DateTime(today.year, today.month, today.day, today.hour);
    return currentHour;
  }

  DateTime getLastHour() {
    DateTime currentHour =
        DateTime(today.year, today.month, today.day, today.hour);
    return currentHour.subtract(const Duration(hours: 24));
  }

  String formatDate(DateTime date) {
    // Force English locale to ensure ASCII digits for API (yyyy-MM-dd)
    return DateFormat('yyyy-MM-dd', 'en').format(date);
  }

  String formatStringDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      return DateFormat('d MMM y, hh:mm a').format(DateTime.parse(date));
    } catch (_) {
      return '-';
    }
  }

  ///This method will return date with timestamp

  dynamic getToday() {
    DateTime now = DateTime.now();
    return formatDate(now);
  }

  dynamic getYesterday() {
    DateTime start = today.subtract(const Duration(days: 1));
    return formatDate(start);
  }

  dynamic getPreviousDay() {
    DateTime start = today.subtract(const Duration(days: 2));
    return formatDate(start);
  }
}
