// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  address1: json['address1'] as String?,
  address2: json['address2'] as String?,
  country: json['country'] as String?,
  state: json['state'] as String?,
  city: json['city'] as String?,
  postCode: json['postCode'],
  phone: json['phone'],
  userId: json['userId'],
  latitude: json['latitude'],
  longitude: json['longitude'],
  label: json['label'] as String?,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'address1': instance.address1,
  'address2': instance.address2,
  'country': instance.country,
  'state': instance.state,
  'city': instance.city,
  'postCode': instance.postCode,
  'phone': instance.phone,
  'userId': instance.userId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'label': instance.label,
};
