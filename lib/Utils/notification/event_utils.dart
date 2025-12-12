

import '../../Models/calender/event_item.dart';

bool dayHasEvent(DateTime day, List<EventItem>? events) {
  if (events == null || events.isEmpty) return false;
  final d = DateTime(day.year, day.month, day.day);
  for (final e in events) {
    final start = e.startAt;
    final end = e.endAt ?? e.startAt;
    if (start == null) continue;
    final s = DateTime(start.year, start.month, start.day);
    final ee = end == null ? s : DateTime(end.year, end.month, end.day);
    if (!d.isBefore(s) && !d.isAfter(ee)) return true;
  }
  return false;
}

bool dayIsWeekend(DateTime day, List<int> weekendDays) {
  // DateTime.weekday: Monday=1 ... Sunday=7
  return weekendDays.contains(day.weekday);
}

/// Returns true if the day should be considered blocked (event OR weekend)
bool dayIsBlocked(DateTime day, {required List<EventItem>? events, required List<int> weekendDays}) {
  return dayIsWeekend(day, weekendDays) || dayHasEvent(day, events);
}

/// Finds the next date on or after [from] that does not have events/weekend.
/// Scans up to [maxDays] into the future.
DateTime nextNonBlockedDay(DateTime from, {required List<EventItem>? events, required List<int> weekendDays, int maxDays = 30}) {
  var candidate = DateTime(from.year, from.month, from.day);
  int steps = 0;
  while (steps < maxDays && dayIsBlocked(candidate, events: events, weekendDays: weekendDays)) {
    candidate = candidate.add(const Duration(days: 1));
    steps++;
  }
  if (dayIsBlocked(candidate, events: events, weekendDays: weekendDays)) {
    candidate = candidate.add(const Duration(days: 1));
  }
  return candidate;
}
