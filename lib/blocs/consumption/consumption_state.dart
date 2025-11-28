part of 'consumption_bloc.dart';

@immutable
sealed class ConsumptionState {}

final class ConsumptionInitial extends ConsumptionState {}

final class ConsumptionBlocInitialized extends ConsumptionState {}
