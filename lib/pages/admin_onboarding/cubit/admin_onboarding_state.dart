part of 'admin_onboarding_cubit.dart';

@immutable
sealed class AdminOnboardingState {}

final class AdminOnboardingInitial extends AdminOnboardingState {}

final class AdminOnboardingLoaded extends AdminOnboardingState {
  final List<Request> requests;
  AdminOnboardingLoaded({required this.requests});
}

final class AdminOnboardingRequestLoaded extends AdminOnboardingState {
  final Request request;
  final String? error;
  AdminOnboardingRequestLoaded({required this.request, this.error});
}

final class AdminOnboardingError extends AdminOnboardingState {
  final String error;
  AdminOnboardingError({required this.error});
}
