import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach/model/conversions.dart';
import 'package:json_annotation/json_annotation.dart';

import 'drink.dart';
import 'enums.dart';

part 'consumption.g.dart';

@JsonSerializable(explicitToJson: true)
class Consumption {
  final String id;
  final String uid;
  @JsonKey(name: 'drink_id')
  final String drinkId;
  @JsonKey(name: 'drink_size')
  final DrinkSize drinkSize;
  @JsonKey(name: 'amount_in_ml')
  final double amountInMl;
  @JsonKey(name: 'consumption_date')
  @TimestampConverter()
  final DateTime consumptionDate;
  @JsonKey(name: 'creation_date')
  @TimestampConverter()
  final DateTime creationDate;
  @JsonKey(name: 'update_date')
  @TimestampConverter()
  final DateTime updateDate;
  Drink? _drink;

  Consumption({
    required this.id,
    required this.uid,
    required this.drinkId,
    required this.drinkSize,
    required this.consumptionDate,
    required this.amountInMl,
    required this.creationDate,
    required this.updateDate,
  });

  Drink? get drink {
    return _drink;
  }

  set drink(Drink? value) {
    _drink = value;
  }

  DateTime toMonthStart() {
    return DateTime(consumptionDate.year, consumptionDate.month, 1);
  }

  double get calories {
    if (_drink == null) {
      return 0;
    }
    if (_drink!.drinkType == DrinkType.cocktail) {
      return _drink!.cocktailRecipe?.totalCalories ?? 0;
    } else {
      if (_drink!.drinkInfo == null) {
        return 0;
      } else {
        return (drinkSize.volumeInML *
            _drink!.drinkInfo!.caloriesPerServingInKCal /
            _drink!.drinkInfo!.servingSizeInMl);
      }
    }
  }

  double get units {
    if (_drink == null) {
      return 0;
    }
    if (_drink!.drinkType == DrinkType.cocktail &&
        _drink!.cocktailRecipe != null) {
      return _drink!.cocktailRecipe!.alcoholByVolumePercent *
          _drink!.cocktailRecipe!.totalVolume /
          1000;
    }
    if (_drink!.drinkInfo == null) {
      return 0;
    } else {
      return (drinkSize.volumeInML *
          _drink!.drinkInfo!.alcoholByVolumePercentage /
          1000);
    }
  }

  factory Consumption.fromJson(Map<String, dynamic> json) =>
      _$ConsumptionFromJson(json);

  Map<String, dynamic> toJson() => _$ConsumptionToJson(this);

  factory Consumption.fromQueryDocmentSnapshot(QueryDocumentSnapshot qs) =>
      Consumption.fromJson({
        ...(qs.data() as Map<String, dynamic>),
        'id': qs.id,
      });

  static double totalCalories(List<Consumption> consumptions) {
    double total = 0;
    for (var cons in consumptions) {
      total += cons.calories;
    }
    return total;
  }

  static double totalUnits(List<Consumption> consumptions) {
    double total = 0;
    for (var cons in consumptions) {
      total += cons.units;
    }
    return total;
  }

  Consumption copyWith({
    String? id,
    String? uid,
    String? drinkId,
    DrinkSize? drinkSize,
    DateTime? consumptionDate,
    double? amountInMl,
    DateTime? creationDate,
    DateTime? updateDate,
    Drink? drink,
  }) {
    return Consumption(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      drinkId: drinkId ?? this.drinkId,
      drinkSize: drinkSize ?? this.drinkSize,
      consumptionDate: consumptionDate ?? this.consumptionDate,
      amountInMl: amountInMl ?? this.amountInMl,
      creationDate: creationDate ?? this.creationDate,
      updateDate: updateDate ?? this.updateDate,
    )..drink = drink ?? this.drink;
  }
}
