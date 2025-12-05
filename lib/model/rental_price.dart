import 'package:json_annotation/json_annotation.dart';

part 'rental_price.g.dart';

@JsonSerializable()
class RentalPrice {
  final int numberOfMonths;
  final double priceInUsdPerHour;

  RentalPrice({required this.numberOfMonths, required this.priceInUsdPerHour});

  factory RentalPrice.fromJson(Map<String, dynamic> json) =>
      _$RentalPriceFromJson(json);

  Map<String, dynamic> toJson() => _$RentalPriceToJson(this);
}
