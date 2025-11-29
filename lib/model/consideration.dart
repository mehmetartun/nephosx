import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'consideration.g.dart';

@JsonSerializable()
class Consideration {
  final double amount;
  final Currency currency;

  Consideration({required this.amount, required this.currency});

  factory Consideration.fromJson(Map<String, dynamic> json) =>
      _$ConsiderationFromJson(json);

  Map<String, dynamic> toJson() => _$ConsiderationToJson(this);
}
