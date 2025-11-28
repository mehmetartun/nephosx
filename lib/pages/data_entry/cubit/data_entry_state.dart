part of 'data_entry_cubit.dart';

sealed class DataEntryState {}

final class DataEntryInitial extends DataEntryState {}

final class DataEntryLoading extends DataEntryState {}

final class DataEntryItem extends DataEntryState {}

final class DataEntryLoaded extends DataEntryState {}

final class DrinksLoaded extends DataEntryState {}

final class DrinksMain extends DataEntryState {}

final class DrinkLoaded extends DataEntryState {
  final Drink drink;
  DrinkLoaded(this.drink);
}
