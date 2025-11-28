import 'consumption.dart';

class MonthSummary {
  final DateTime month;
  final double totalUnits;
  final double totalCalories;
  final List<Consumption> consumptions;

  MonthSummary({
    required this.month,
    required this.totalUnits,
    required this.totalCalories,
    required this.consumptions,
  });
}
