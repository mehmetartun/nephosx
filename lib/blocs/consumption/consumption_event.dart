part of 'consumption_bloc.dart';

@immutable
sealed class ConsumptionEvent {}

final class ConsumptionEventAddDrink extends ConsumptionEvent {
  final Drink drink;
  final double amountInMl;
  final User user;
  final DateTime consumptionDate;
  ConsumptionEventAddDrink({
    required this.drink,
    required this.amountInMl,
    required this.user,
    required this.consumptionDate,
  });
}

final class ConsumptionInitializationCompleteEvent extends ConsumptionEvent {}
