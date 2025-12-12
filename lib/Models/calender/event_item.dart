import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_item.freezed.dart';
part 'event_item.g.dart';

/// Calendar event/holiday item returned from `eventsUrl`
@freezed
abstract class EventItem with _$EventItem {
  const factory EventItem({
    int? id,
    String? start,
    String? end,
    String? color,
    String? title,
    String? img,
    bool? holiday,
  }) = _EventItem;

  const EventItem._();

  factory EventItem.fromJson(Map<String, dynamic> json) => _$EventItemFromJson(json);

  /// Helpers to get DateTimes (date-only if the API provides only date)
  DateTime? get startAt => _tryParseDate(start);
  DateTime? get endAt => _tryParseDate(end);

  bool get isHoliday => holiday == true;

  DateTime? _tryParseDate(String? s) {
    if (s == null || s.isEmpty) return null;
    // Try full date-time first
    try {
      return DateTime.parse(s).toLocal();
    } catch (_) {
      // Try date-only (YYYY-MM-DD)
      try {
        final dt = DateTime.tryParse('${s.trim()} 00:00:00');
        return dt?.toLocal();
      } catch (_) {
        return null;
      }
    }
  }
}
