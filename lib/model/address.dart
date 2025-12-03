import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address {
  // final String id;
  // final String entityId;
  // final EntityType entityType;
  final String? id;
  final String? parentId;
  final String addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String zipCode;
  final String city;
  final AddressState? state;
  final Country country;
  final String? description;

  Address({
    // required this.id,
    this.id,
    this.parentId,
    required this.addressLine1,
    this.addressLine2,
    required this.zipCode,
    required this.city,
    this.state,
    required this.country,
    this.addressLine3,
    this.description,
    // required this.entityId,
    // required this.entityType,
  });

  Address copyWith(
    String? id,
    String? parentId,
    String? addressLine1,
    String? addressLine2,
    String? addressLine3,
    String? zipCode,
    String? city,
    AddressState? state,
    Country? country,
    String? description,
    // String? entityId,
    // EntityType? entityType,
  ) {
    return Address(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      addressLine3: addressLine3 ?? this.addressLine3,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      description: description ?? this.description,
      // entityId: entityId ?? this.entityId,
      // entityType: entityType ?? this.entityType,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  String toString() {
    late String text;
    text = addressLine1;
    if (addressLine2 != null) {
      text += "\n${addressLine2!}";
    }
    if (addressLine3 != null) {
      text += "\n${addressLine3!}";
    }
    text += "\n$zipCode $city";
    if (state != null) {
      text += " ${state!.description}";
    }
    text += "\n${country.description}";
    return text;
  }
}
