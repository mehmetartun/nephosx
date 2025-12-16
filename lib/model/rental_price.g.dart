// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RentalPrice _$RentalPriceFromJson(Map<String, dynamic> json) => RentalPrice(
  numberOfUnits: (json['number_of_units'] as num).toInt(),
  pricePerHour: Consideration.fromJson(
    json['price_per_hour'] as Map<String, dynamic>,
  ),
  rentalPriceType:
      $enumDecodeNullable(
        _$RentalPriceTypeEnumMap,
        json['rental_price_type'],
      ) ??
      RentalPriceType.monthly,
);

Map<String, dynamic> _$RentalPriceToJson(RentalPrice instance) =>
    <String, dynamic>{
      'number_of_units': instance.numberOfUnits,
      'price_per_hour': instance.pricePerHour.toJson(),
      'rental_price_type': _$RentalPriceTypeEnumMap[instance.rentalPriceType]!,
    };

const _$RentalPriceTypeEnumMap = {
  RentalPriceType.monthly: 'monthly',
  RentalPriceType.weekly: 'weekly',
  RentalPriceType.daily: 'daily',
};
