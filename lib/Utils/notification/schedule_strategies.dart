import 'package:timezone/timezone.dart' as tz;
import 'event_utils.dart';

/// Strategy for scheduling checkout notifications.
/// - todayOnly: schedule only if today's checkout time is in the future.
/// - likeCheckIn: move to next non-blocked day (event/weekend) if today passed.
/// - afterCheckInNextNonEvent: align checkout on the next valid non-blocked day, even if today.
enum CheckoutScheduleMode { todayOnly, likeScheduleIn, afterScheduleInNextNonEvent }

class ScheduleResult {
  final DateTime? scheduleIn;
  final DateTime? scheduleOut;
  const ScheduleResult({this.scheduleIn, this.scheduleOut});
}

DateTime _compose(DateTime baseDay, DateTime baseTimeOfDay) => DateTime(
  baseDay.year,
  baseDay.month,
  baseDay.day,
  baseTimeOfDay.hour,
  baseTimeOfDay.minute,
  baseTimeOfDay.second,
);

/// Computes the next check-in time, skipping event days and weekends.
DateTime? computeNextCheckIn({
  required DateTime now,
  required DateTime? baseCheckInToday,
  required List events,
  required List<int> weekendDays,
}) {
  if (baseCheckInToday == null) return null;
  var candidate = _compose(now, baseCheckInToday);
  if (!candidate.isAfter(now)) {
    candidate = candidate.add(const Duration(days: 1));
  }
  final nextDay = nextNonBlockedDay(
    candidate,
    events: events.cast(),
    weekendDays: weekendDays,
  );
  return _compose(nextDay, baseCheckInToday);
}

/// Computes the checkout time based on selected mode, honoring weekends/events.
DateTime? computeNextCheckOut({
  required DateTime now,
  required DateTime? baseCheckOutToday,
  required List events,
  required List<int> weekendDays,
  required CheckoutScheduleMode mode,
  DateTime? referenceCheckIn,
}) {
  if (baseCheckOutToday == null) return null;

  switch (mode) {
    case CheckoutScheduleMode.todayOnly:
      final candidate = _compose(now, baseCheckOutToday);
      return candidate.isAfter(now) ? candidate : null;

    case CheckoutScheduleMode.likeScheduleIn:
      // Mirror the check-in scan logic for checkout.
      var candidate = _compose(now, baseCheckOutToday);
      if (!candidate.isAfter(now)) {
        candidate = candidate.add(const Duration(days: 1));
      }
      final nextDay = nextNonBlockedDay(
        candidate,
        events: events.cast(),
        weekendDays: weekendDays,
      );
      return _compose(nextDay, baseCheckOutToday);

    case CheckoutScheduleMode.afterScheduleInNextNonEvent:
      // If referenceCheckIn provided, schedule checkout on that same day/time-of-day.
      // Also ensure the resulting time is in the future; if not, advance to the next
      // valid non-blocked day.
      DateTime start = referenceCheckIn ?? now;
      var day = nextNonBlockedDay(
        start,
        events: events.cast(),
        weekendDays: weekendDays,
      );
      var result = _compose(day, baseCheckOutToday);
      if (!result.isAfter(now)) {
        // advance one day and find next valid day
        day = nextNonBlockedDay(
          day.add(const Duration(days: 1)),
          events: events.cast(),
          weekendDays: weekendDays,
        );
        result = _compose(day, baseCheckOutToday);
      }
      return result;
  }
}

/// Utility to convert a wall-clock DateTime to tz.TZDateTime in local timezone.
tz.TZDateTime toTz(DateTime d) => tz.TZDateTime.from(d, tz.local);
