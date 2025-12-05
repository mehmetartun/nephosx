import 'package:json_annotation/json_annotation.dart';

part 'rental_price.g.dart';

@JsonSerializable()
class RentalPrice {
  @JsonKey(name: "number_of_months")
  final int numberOfMonths;
  @JsonKey(name: "price_in_usd_per_hour")
  final double priceInUsdPerHour;

  RentalPrice({required this.numberOfMonths, required this.priceInUsdPerHour});

  factory RentalPrice.fromJson(Map<String, dynamic> json) =>
      _$RentalPriceFromJson(json);

  Map<String, dynamic> toJson() => _$RentalPriceToJson(this);
}
