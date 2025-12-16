import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/model/consideration.dart';

import 'enums.dart';

part 'rental_price.g.dart';

enum RentalPriceType {
  monthly("monthly", "/m", 30),
  weekly("weekly", "/wk", 7),
  daily("daily", "/d", 1);

  final String title;
  final String formatSymbol;
  final int daysPerUnit;

  const RentalPriceType(this.title, this.formatSymbol, this.daysPerUnit);
}

@JsonSerializable(explicitToJson: true)
class RentalPrice {
  @JsonKey(name: "number_of_units")
  final int numberOfUnits;
  @JsonKey(name: "price_per_hour")
  final Consideration pricePerHour;
  @JsonKey(name: "rental_price_type")
  final RentalPriceType rentalPriceType;

  RentalPrice({
    required this.numberOfUnits,
    required this.pricePerHour,
    this.rentalPriceType = RentalPriceType.monthly,
  });

  // String get priceInUsdPerHourFormatted => NumberFormat.currency(
  //   locale: 'en_US',
  //   symbol: '\$',
  //   decimalDigits: 3,
  // ).format(priceInUsdPerHour);

  int get numberOfDays {
    return numberOfUnits * rentalPriceType.daysPerUnit;
  }

  String get pricePerHourFormatted {
    if (pricePerHour.currency == Currency.usd) {
      return NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
        decimalDigits: 3,
      ).format(pricePerHour.amount);
    } else if (pricePerHour.currency == Currency.eur) {
      return NumberFormat.currency(
        locale: 'en_US',
        symbol: '€',
        decimalDigits: 3,
      ).format(pricePerHour.amount);
    } else if (pricePerHour.currency == Currency.gbp) {
      return NumberFormat.currency(
        locale: 'en_US',
        symbol: '£',
        decimalDigits: 3,
      ).format(pricePerHour.amount);
    } else {
      return NumberFormat.currency(
        locale: 'en_US',
        symbol: pricePerHour.currency.title,
        decimalDigits: 3,
      ).format(pricePerHour.amount);
    }
  }

  String get pricePerHourFormattedWithUnits {
    return pricePerHourFormatted + rentalPriceType.formatSymbol;
  }

  // String get priceInUsdPerHourFormattedWithMonths {
  //   return "${numberOfUnits}m: $priceInUsdPerHourFormatted/hr";
  // }

  factory RentalPrice.fromJson(Map<String, dynamic> json) =>
      _$RentalPriceFromJson(json);

  Map<String, dynamic> toJson() => _$RentalPriceToJson(this);

  static Consideration calculatePrice(
    List<RentalPrice> prices,
    DateTime from,
    DateTime to,
  ) {
    final List<RentalPrice> _prices = prices.toList();
    final int numDays = to.difference(from).inDays;
    _prices.sort((a, b) => a.numberOfDays.compareTo(b.numberOfDays));
    if (_prices.length == 1) {
      return Consideration(
        currency: _prices.first.pricePerHour.currency,
        amount:
            _prices.first.pricePerHour.amount *
            Duration.hoursPerDay *
            to.difference(from).inDays,
      );
    }
    if (_prices.isEmpty) {
      return Consideration(amount: 0, currency: Currency.usd);
    }
    if (_prices.length > 1) {
      if (numDays <= _prices.first.numberOfDays) {
        return Consideration(
          currency: _prices.first.pricePerHour.currency,
          amount:
              _prices.first.pricePerHour.amount *
              Duration.hoursPerDay *
              to.difference(from).inDays,
        );
      }
      for (var i = 1; i < _prices.length; i++) {
        if (_prices[i - 1].numberOfDays < numDays &&
            numDays < _prices[i].numberOfDays) {
          return Consideration(
            currency: _prices[i].pricePerHour.currency,
            amount:
                _prices[i].pricePerHour.amount *
                Duration.hoursPerDay *
                to.difference(from).inDays,
          );
        }
      }
      return Consideration(
        currency: _prices.last.pricePerHour.currency,
        amount:
            _prices.last.pricePerHour.amount *
            Duration.hoursPerDay *
            to.difference(from).inDays,
      );
    }
    // return 0;
    return Consideration(amount: 0, currency: Currency.usd);
  }
}
