part of 'corp_user_acceptance_cubit.dart';

sealed class CorpUserAcceptanceState {}

final class CorpUserAcceptanceInitial extends CorpUserAcceptanceState {}

final class CorpUserAcceptanceLoading extends CorpUserAcceptanceState {}

final class CorpUserAcceptanceLoaded extends CorpUserAcceptanceState {
  final Invitation invitation;
  CorpUserAcceptanceLoaded({required this.invitation});
}

final class CorpUserAcceptanceError extends CorpUserAcceptanceState {
  final String title;
  final String message;
  CorpUserAcceptanceError({required this.title, required this.message});
}

final class CorpUserAcceptanceSuccess extends CorpUserAcceptanceState {
  final String title;
  final String message;
  CorpUserAcceptanceSuccess({required this.title, required this.message});
}
