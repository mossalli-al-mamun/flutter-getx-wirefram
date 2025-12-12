// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventItem _$EventItemFromJson(Map<String, dynamic> json) => _EventItem(
  id: (json['id'] as num?)?.toInt(),
  start: json['start'] as String?,
  end: json['end'] as String?,
  color: json['color'] as String?,
  title: json['title'] as String?,
  img: json['img'] as String?,
  holiday: json['holiday'] as bool?,
);

Map<String, dynamic> _$EventItemToJson(_EventItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start': instance.start,
      'end': instance.end,
      'color': instance.color,
      'title': instance.title,
      'img': instance.img,
      'holiday': instance.holiday,
    };
