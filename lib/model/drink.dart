// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephosx/model/conversions.dart';
import 'package:json_annotation/json_annotation.dart';

import 'cocktail_recipe.dart';
import 'drink_info.dart';
import 'enums.dart';

part 'drink.g.dart';

@JsonSerializable(explicitToJson: true)
class Drink {
  final String id;
  final String name;
  // final String description;
  final String imageBase64;
  final DrinkType drinkType;
  // final Set<ServingFormat> servingFormats;
  // final double servingVolumeInMl;
  // final double alcoholPercentage;
  @TimestampConverter()
  final DateTime createdAt;
  @TimestampConverter()
  final DateTime lastUpdateAt;
  @JsonKey(name: 'recipe')
  final CocktailRecipe? cocktailRecipe;
  @JsonKey(name: 'info')
  final DrinkInfo? drinkInfo;

  Drink({
    required this.id,
    required this.name,
    // required this.description,
    required this.imageBase64,
    required this.drinkType,
    // required this.servingFormats,
    // required this.servingVolumeInMl,
    // required this.alcoholPercentage,
    required this.createdAt,
    required this.lastUpdateAt,
    this.cocktailRecipe,
    this.drinkInfo,
  });

  Drink copyWith({
    String? id,
    String? name,
    // String? description,
    String? imageBase64,
    DrinkType? drinkType,
    // Set<ServingFormat>? servingFormats,
    // double? servingVolumeInMl,
    // double? alcoholPercentage,
    DateTime? createdAt,
    DateTime? lastUpdateAt,
    CocktailRecipe? cocktailRecipe,
    DrinkInfo? drinkInfo,
  }) {
    return Drink(
      id: id ?? this.id,
      name: name ?? this.name,
      // description: description ?? this.description,
      imageBase64: imageBase64 ?? this.imageBase64,
      drinkType: drinkType ?? this.drinkType,
      // servingFormats: servingFormats ?? this.servingFormats,
      // servingVolumeInMl: servingVolumeInMl ?? this.servingVolumeInMl,
      // alcoholPercentage: alcoholPercentage ?? this.alcoholPercentage,
      createdAt: createdAt ?? this.createdAt,
      lastUpdateAt: lastUpdateAt ?? this.lastUpdateAt,
      cocktailRecipe: cocktailRecipe ?? this.cocktailRecipe,
      drinkInfo: drinkInfo ?? this.drinkInfo,
    );
  }

  double get alcoholVolumeInMl {
    // TODO: Fix this
    // return servingVolumeInMl * (alcoholPercentage / 100);
    return 10;
  }

  double get alcoholCalories {
    // TODO: Fix this
    // return alcoholVolumeInMl * 0.789 * 7;
    return 100;
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'name': name,
  //     'description': description,
  //     'imageBase64': imageBase64,
  //     'drinkType': drinkType.name,
  //     'servingFormats': servingFormats.map((x) => x.name).toList(),
  //     'servingVolumeInMl': servingVolumeInMl,
  //     'alcoholPercentage': alcoholPercentage,
  //     'createdAt': firestore.Timestamp.fromDate(createdAt),
  //     'lastUpdateAt': firestore.Timestamp.fromDate(lastUpdateAt),
  //     'recipe': cocktailRecipe?.toJson(),
  //   };
  // }

  // static Set<ServingFormat> parseServingFormats(List<dynamic> list) {
  //   return list
  //       .map((val) {
  //         return ServingFormat.values.firstWhere((e) => e.name == val);
  //       })
  //       .toList()
  //       .toSet();
  // }

  // factory Drink.fromMap(Map<String, dynamic> map, String id) {
  //   return Drink(
  //     id: id,
  //     name: map['name'] as String,
  //     description: map['description'] as String,
  //     imageBase64: map['imageBase64'] as String,
  //     drinkType: DrinkType.values.firstWhere((e) => e.name == map['drinkType']),
  //     servingFormats: parseServingFormats(
  //       map['servingFormats'] as List<dynamic>,
  //     ),
  //     servingVolumeInMl: map['servingVolumeInMl'] is int
  //         ? map['servingVolumeInMl'].toDouble()
  //         : map['servingVolumeInMl'],
  //     alcoholPercentage: map['alcoholPercentage'] is int
  //         ? map['alcoholPercentage'].toDouble()
  //         : map['alcoholPercentage'],
  //     createdAt: (map['createdAt'] as firestore.Timestamp).toDate(),
  //     lastUpdateAt: (map['lastUpdateAt'] as firestore.Timestamp).toDate(),
  //     cocktailRecipe: map['recipe'] != null
  //         ? CocktailRecipe.fromJson(map['recipe'] as Map<String, dynamic>)
  //         : null,
  //   );
  // }

  // String get servingFormatString {
  //   return servingFormats.map((e) => e.name).join(', ');
  // }

  // String toJson() => json.encode(toMap());

  // factory Drink.fromJson(String source) =>
  //     Drink.fromMap(json.decode(source) as Map<String, dynamic>,);

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkToJson(this);

  @override
  String toString() {
    return 'Drink(id: $id, name: $name'
        '\ndrinkType: $drinkType)';
  }

  // @override
  // bool operator ==(covariant Drink other) {
  //   if (identical(this, other)) return true;

  //   return other.id == id &&
  //       other.name == name &&
  //       other.description == description &&
  //       other.imageBase64 == imageBase64 &&
  //       other.drinkType == drinkType &&
  //       other.servingVolumeInMl == servingVolumeInMl &&
  //       other.alcoholPercentage == alcoholPercentage &&
  //       other.createdAt == createdAt &&
  //       other.lastUpdateAt == lastUpdateAt &&
  //       setEquals(other.servingFormats, servingFormats);
  // }

  // @override
  // int get hashCode {
  //   return id.hashCode ^
  //       name.hashCode ^
  //       description.hashCode ^
  //       imageBase64.hashCode ^
  //       drinkType.hashCode ^
  //       servingVolumeInMl.hashCode ^
  //       alcoholPercentage.hashCode ^
  //       createdAt.hashCode ^
  //       lastUpdateAt.hashCode ^
  //       servingFormats.hashCode;
  // }
}
