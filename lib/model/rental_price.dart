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

  static double calculatePrice(
    List<RentalPrice> prices,
    DateTime from,
    DateTime to,
  ) {
    final List<RentalPrice> _prices = prices.toList();
    final double numMonths = to.difference(from).inDays / 30;
    _prices.sort((a, b) => a.numberOfMonths.compareTo(b.numberOfMonths));
    if (_prices.length == 1) {
      return _prices.first.priceInUsdPerHour *
          Duration.hoursPerDay *
          to.difference(from).inDays;
    }
    if (_prices.isEmpty) {
      return 0;
    }
    if (_prices.length > 1) {
      if (numMonths < _prices.first.numberOfMonths) {
        return _prices.first.priceInUsdPerHour *
            Duration.hoursPerDay *
            to.difference(from).inDays;
      }
      for (var i = 1; i < _prices.length; i++) {
        if (_prices[i - 1].numberOfMonths < numMonths &&
            numMonths < _prices[i].numberOfMonths) {
          return _prices[i].priceInUsdPerHour *
              Duration.hoursPerDay *
              to.difference(from).inDays;
        }
      }
      return _prices.last.priceInUsdPerHour *
          Duration.hoursPerDay *
          to.difference(from).inDays;
    }
    return 0;
  }
}
