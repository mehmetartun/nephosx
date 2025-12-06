import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'consideration.g.dart';

@JsonSerializable()
class Consideration {
  final double amount;
  final Currency currency;

  String get formatted {
    if (currency == Currency.usd) {
      return NumberFormat.simpleCurrency(locale: 'en_US').format(amount);
    } else if (currency == Currency.eur) {
      return NumberFormat.simpleCurrency(locale: 'en_EU').format(amount);
    } else if (currency == Currency.gbp) {
      return NumberFormat.simpleCurrency(locale: 'en_GB').format(amount);
    } else if (currency == Currency.jpy) {
      return NumberFormat.simpleCurrency(locale: 'ja_JP').format(amount);
    } else {
      return "${currency.title} ${amount.toStringAsFixed(2)}";
    }
  }

  String hourlyRate({required DateTime startDate, required DateTime endDate}) {
    return NumberFormat.simpleCurrency(
      locale: 'en_US',
    ).format(amount / endDate.difference(startDate).inHours);
  }

  Consideration({required this.amount, required this.currency});

  factory Consideration.fromJson(Map<String, dynamic> json) =>
      _$ConsiderationFromJson(json);

  Map<String, dynamic> toJson() => _$ConsiderationToJson(this);
}
