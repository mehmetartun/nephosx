class DaySummary {
  final DateTime day;
  final double totalUnits;
  final double totalCalories;
  final List<Map<String, dynamic>> consumptions;

  DaySummary({
    required this.day,
    required this.totalUnits,
    required this.totalCalories,
    required this.consumptions,
  });
}
