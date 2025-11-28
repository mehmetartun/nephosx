import 'package:json_annotation/json_annotation.dart';

part 'production_ingredient.g.dart';

@JsonSerializable()
class ProductionIngredient {
  final String name;
  final String description;

  factory ProductionIngredient.fromJson(Map<String, dynamic> json) =>
      _$ProductionIngredientFromJson(json);

  ProductionIngredient({required this.name, required this.description});

  Map<String, dynamic> toJson() => _$ProductionIngredientToJson(this);
}
