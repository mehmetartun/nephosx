// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RentalPrice _$RentalPriceFromJson(Map<String, dynamic> json) => RentalPrice(
  numberOfMonths: (json['numberOfMonths'] as num).toInt(),
  priceInUsdPerHour: (json['priceInUsdPerHour'] as num).toDouble(),
);

Map<String, dynamic> _$RentalPriceToJson(RentalPrice instance) =>
    <String, dynamic>{
      'numberOfMonths': instance.numberOfMonths,
      'priceInUsdPerHour': instance.priceInUsdPerHour,
    };
