// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consumption _$ConsumptionFromJson(Map<String, dynamic> json) =>
    Consumption(
        id: json['id'] as String,
        uid: json['uid'] as String,
        drinkId: json['drink_id'] as String,
        drinkSize: $enumDecode(_$DrinkSizeEnumMap, json['drink_size']),
        consumptionDate: const TimestampConverter().fromJson(
          json['consumption_date'] as Timestamp,
        ),
        amountInMl: (json['amount_in_ml'] as num).toDouble(),
        creationDate: const TimestampConverter().fromJson(
          json['creation_date'] as Timestamp,
        ),
        updateDate: const TimestampConverter().fromJson(
          json['update_date'] as Timestamp,
        ),
      )
      ..drink = json['drink'] == null
          ? null
          : Drink.fromJson(json['drink'] as Map<String, dynamic>);

Map<String, dynamic> _$ConsumptionToJson(Consumption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'drink_id': instance.drinkId,
      'drink_size': _$DrinkSizeEnumMap[instance.drinkSize]!,
      'amount_in_ml': instance.amountInMl,
      'consumption_date': const TimestampConverter().toJson(
        instance.consumptionDate,
      ),
      'creation_date': const TimestampConverter().toJson(instance.creationDate),
      'update_date': const TimestampConverter().toJson(instance.updateDate),
      'drink': instance.drink?.toJson(),
    };

const _$DrinkSizeEnumMap = {
  DrinkSize.smallGlass: 'small_glass',
  DrinkSize.mediumGlass: 'medium_glass',
  DrinkSize.largeGlass: 'large_glass',
  DrinkSize.amount330ml: 'amount330ml',
  DrinkSize.amount500ml: 'amount500ml',
  DrinkSize.amount250ml: 'amount250ml',
  DrinkSize.amount300ml: 'amount300ml',
  DrinkSize.amount200ml: 'amount200ml',
  DrinkSize.amount1l: 'amount1l',
  DrinkSize.amountPint: 'amount_pint',
  DrinkSize.amountHalfPint: 'amount_half_pint',
  DrinkSize.amount8oz: 'amount8oz',
  DrinkSize.amount12oz: 'amount12oz',
  DrinkSize.amount16oz: 'amount16oz',
  DrinkSize.amount20oz: 'amount20oz',
  DrinkSize.amount440ml: 'amount440ml',
  DrinkSize.oneCocktail: 'one_cocktail',
  DrinkSize.singleShot: 'single_shot',
  DrinkSize.doubleShot: 'double_shot',
};
