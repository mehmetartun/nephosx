// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RentalPrice _$RentalPriceFromJson(Map<String, dynamic> json) => RentalPrice(
  numberOfMonths: (json['number_of_months'] as num).toInt(),
  priceInUsdPerHour: (json['price_in_usd_per_hour'] as num).toDouble(),
);

Map<String, dynamic> _$RentalPriceToJson(RentalPrice instance) =>
    <String, dynamic>{
      'number_of_months': instance.numberOfMonths,
      'price_in_usd_per_hour': instance.priceInUsdPerHour,
    };
