import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    String? firstName,
    String? lastName,
    String? address1,
    String? address2,
    String? country,
    String? state,
    String? city,
    dynamic postCode,
    dynamic phone,
    dynamic userId,
    dynamic latitude,
    dynamic longitude,
    String? label,

  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}