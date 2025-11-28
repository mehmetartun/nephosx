// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkInfo _$DrinkInfoFromJson(Map<String, dynamic> json) => DrinkInfo(
  name: json['name'] as String,
  description: json['description'] as String,
  servingSizeInMl: (json['serving_size_in_mL'] as num).toDouble(),
  caloriesPerServingInKCal: (json['calories_per_serving_in_kCal'] as num)
      .toDouble(),
  history: json['history'] as String,
  alcoholByVolumePercentage: (json['alcohol_by_volume_%'] as num).toDouble(),
  servingFormat: json['serving_format'] as String,
  totalCarbohydratesInG: (json['total_carbohydrates_in_g'] as num).toDouble(),
  totalProteinInG: (json['total_protein_in_g'] as num).toDouble(),
  totalFatInG: (json['total_fat_in_g'] as num).toDouble(),
  productionIngredients:
      (json['ingredients_used_in_production'] as List<dynamic>)
          .map((e) => ProductionIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DrinkInfoToJson(DrinkInfo instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'serving_size_in_mL': instance.servingSizeInMl,
  'calories_per_serving_in_kCal': instance.caloriesPerServingInKCal,
  'history': instance.history,
  'alcohol_by_volume_%': instance.alcoholByVolumePercentage,
  'serving_format': instance.servingFormat,
  'total_carbohydrates_in_g': instance.totalCarbohydratesInG,
  'total_protein_in_g': instance.totalProteinInG,
  'total_fat_in_g': instance.totalFatInG,
  'ingredients_used_in_production': instance.productionIngredients
      .map((e) => e.toJson())
      .toList(),
};
