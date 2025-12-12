// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventItem {

 int? get id; String? get start; String? get end; String? get color; String? get title; String? get img; bool? get holiday;
/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventItemCopyWith<EventItem> get copyWith => _$EventItemCopyWithImpl<EventItem>(this as EventItem, _$identity);

  /// Serializes this EventItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventItem&&(identical(other.id, id) || other.id == id)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.color, color) || other.color == color)&&(identical(other.title, title) || other.title == title)&&(identical(other.img, img) || other.img == img)&&(identical(other.holiday, holiday) || other.holiday == holiday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,start,end,color,title,img,holiday);

@override
String toString() {
  return 'EventItem(id: $id, start: $start, end: $end, color: $color, title: $title, img: $img, holiday: $holiday)';
}


}

/// @nodoc
abstract mixin class $EventItemCopyWith<$Res>  {
  factory $EventItemCopyWith(EventItem value, $Res Function(EventItem) _then) = _$EventItemCopyWithImpl;
@useResult
$Res call({
 int? id, String? start, String? end, String? color, String? title, String? img, bool? holiday
});




}
/// @nodoc
class _$EventItemCopyWithImpl<$Res>
    implements $EventItemCopyWith<$Res> {
  _$EventItemCopyWithImpl(this._self, this._then);

  final EventItem _self;
  final $Res Function(EventItem) _then;

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? start = freezed,Object? end = freezed,Object? color = freezed,Object? title = freezed,Object? img = freezed,Object? holiday = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventItem].
extension EventItemPatterns on EventItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventItem value)  $default,){
final _that = this;
switch (_that) {
case _EventItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventItem value)?  $default,){
final _that = this;
switch (_that) {
case _EventItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? start,  String? end,  String? color,  String? title,  String? img,  bool? holiday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventItem() when $default != null:
return $default(_that.id,_that.start,_that.end,_that.color,_that.title,_that.img,_that.holiday);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? start,  String? end,  String? color,  String? title,  String? img,  bool? holiday)  $default,) {final _that = this;
switch (_that) {
case _EventItem():
return $default(_that.id,_that.start,_that.end,_that.color,_that.title,_that.img,_that.holiday);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? start,  String? end,  String? color,  String? title,  String? img,  bool? holiday)?  $default,) {final _that = this;
switch (_that) {
case _EventItem() when $default != null:
return $default(_that.id,_that.start,_that.end,_that.color,_that.title,_that.img,_that.holiday);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventItem extends EventItem {
  const _EventItem({this.id, this.start, this.end, this.color, this.title, this.img, this.holiday}): super._();
  factory _EventItem.fromJson(Map<String, dynamic> json) => _$EventItemFromJson(json);

@override final  int? id;
@override final  String? start;
@override final  String? end;
@override final  String? color;
@override final  String? title;
@override final  String? img;
@override final  bool? holiday;

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventItemCopyWith<_EventItem> get copyWith => __$EventItemCopyWithImpl<_EventItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventItem&&(identical(other.id, id) || other.id == id)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.color, color) || other.color == color)&&(identical(other.title, title) || other.title == title)&&(identical(other.img, img) || other.img == img)&&(identical(other.holiday, holiday) || other.holiday == holiday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,start,end,color,title,img,holiday);

@override
String toString() {
  return 'EventItem(id: $id, start: $start, end: $end, color: $color, title: $title, img: $img, holiday: $holiday)';
}


}

/// @nodoc
abstract mixin class _$EventItemCopyWith<$Res> implements $EventItemCopyWith<$Res> {
  factory _$EventItemCopyWith(_EventItem value, $Res Function(_EventItem) _then) = __$EventItemCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? start, String? end, String? color, String? title, String? img, bool? holiday
});




}
/// @nodoc
class __$EventItemCopyWithImpl<$Res>
    implements _$EventItemCopyWith<$Res> {
  __$EventItemCopyWithImpl(this._self, this._then);

  final _EventItem _self;
  final $Res Function(_EventItem) _then;

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? start = freezed,Object? end = freezed,Object? color = freezed,Object? title = freezed,Object? img = freezed,Object? holiday = freezed,}) {
  return _then(_EventItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
