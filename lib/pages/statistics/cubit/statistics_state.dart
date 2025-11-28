part of 'statistics_cubit.dart';

sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsRecent extends StatisticsState {
  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> monthData;
  final DateTime? selectedMonth;
  StatisticsRecent({
    required this.data,
    required this.monthData,
    this.selectedMonth,
  });
}

final class StatisticsForMonth extends StatisticsState {
  final ConsumptionPeriod consumptionPeriod;
  final DateTime selectedMonth;
  final void Function() onCancel;
  final void Function(DateTime) onTapDate;

  StatisticsForMonth({
    required this.selectedMonth,
    required this.onCancel,
    required this.onTapDate,
    required this.consumptionPeriod,
  });
}

final class StatisticsForDate extends StatisticsState {
  final ConsumptionPeriod consumptionPeriod;
  final DateTime selectedDate;
  final void Function(DateTime) onCancel;
  final DrinkingNote? drinkingNote;

  StatisticsForDate({
    required this.onCancel,
    required this.consumptionPeriod,
    required this.selectedDate,
    this.drinkingNote,
  });
}

final class StatisticsFull extends StatisticsState {
  final ConsumptionPeriod consumptionPeriod;

  StatisticsFull({required this.consumptionPeriod});
}

final class StatisticsLoading extends StatisticsState {}

final class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError({required this.message});
}
