part of 'profile_cubit.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  ProfileLoaded();
}

final class ProfileError extends ProfileState {
  final String errorMessage;

  ProfileError({required this.errorMessage});
}

final class ProfileEdit extends ProfileState {
  final User user;

  ProfileEdit({required this.user});
}
