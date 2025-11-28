part of 'consumption_entry_cubit.dart';

@immutable
sealed class ConsumptionEntryState {}

final class ConsumptionEntryInitial extends ConsumptionEntryState {}

final class ConsumptionEntryLoading extends ConsumptionEntryState {}

final class ConsumptionEntrySelect extends ConsumptionEntryState {
  final DrinkType? drinkType;
  ConsumptionEntrySelect({this.drinkType});
}

final class ConsumptionEntryForDrinkType extends ConsumptionEntryState {
  final DrinkType drinkType;
  final List<Drink> drinks;
  final Drink? selectedDrink;
  ConsumptionEntryForDrinkType({
    required this.drinkType,
    required this.drinks,
    this.selectedDrink,
  });
}

final class ConsumptionEntryForDrink extends ConsumptionEntryState {
  final Drink drink;
  ConsumptionEntryForDrink({required this.drink});
}
