// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Drink _$DrinkFromJson(Map<String, dynamic> json) => Drink(
  id: json['id'] as String,
  name: json['name'] as String,
  imageBase64: json['imageBase64'] as String,
  drinkType: $enumDecode(_$DrinkTypeEnumMap, json['drinkType']),
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  lastUpdateAt: const TimestampConverter().fromJson(
    json['lastUpdateAt'] as Timestamp,
  ),
  cocktailRecipe: json['recipe'] == null
      ? null
      : CocktailRecipe.fromJson(json['recipe'] as Map<String, dynamic>),
  drinkInfo: json['info'] == null
      ? null
      : DrinkInfo.fromJson(json['info'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DrinkToJson(Drink instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'imageBase64': instance.imageBase64,
  'drinkType': _$DrinkTypeEnumMap[instance.drinkType]!,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'lastUpdateAt': const TimestampConverter().toJson(instance.lastUpdateAt),
  'recipe': instance.cocktailRecipe?.toJson(),
  'info': instance.drinkInfo?.toJson(),
};

const _$DrinkTypeEnumMap = {
  DrinkType.cocktail: 'cocktail',
  DrinkType.beer: 'beer',
  DrinkType.wine: 'wine',
  DrinkType.spirit: 'spirit',
  DrinkType.bubbly: 'bubbly',
  DrinkType.cider: 'cider',
};
