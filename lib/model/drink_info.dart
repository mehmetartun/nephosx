import 'package:json_annotation/json_annotation.dart';

import 'production_ingredient.dart';

part 'drink_info.g.dart';

@JsonSerializable(explicitToJson: true)
class DrinkInfo {
  final String name;
  final String description;
  @JsonKey(name: 'serving_size_in_mL')
  final double servingSizeInMl;
  @JsonKey(name: 'calories_per_serving_in_kCal')
  final double caloriesPerServingInKCal;
  final String history;
  @JsonKey(name: 'alcohol_by_volume_%')
  final double alcoholByVolumePercentage;
  @JsonKey(name: 'serving_format')
  final String servingFormat;
  @JsonKey(name: 'total_carbohydrates_in_g')
  final double totalCarbohydratesInG;
  @JsonKey(name: 'total_protein_in_g')
  final double totalProteinInG;
  @JsonKey(name: 'total_fat_in_g')
  final double totalFatInG;
  @JsonKey(name: 'ingredients_used_in_production')
  final List<ProductionIngredient> productionIngredients;

  DrinkInfo({
    required this.name,
    required this.description,
    required this.servingSizeInMl,
    required this.caloriesPerServingInKCal,
    required this.history,
    required this.alcoholByVolumePercentage,
    required this.servingFormat,
    required this.totalCarbohydratesInG,
    required this.totalProteinInG,
    required this.totalFatInG,
    required this.productionIngredients,
  });

  // double get alcoholUnits {
  //   return totalVolume * alcoholByVolumePercent / 1000;
  // }

  factory DrinkInfo.fromJson(Map<String, dynamic> json) =>
      _$DrinkInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkInfoToJson(this);
}
