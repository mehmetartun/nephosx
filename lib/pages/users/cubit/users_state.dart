part of 'users_cubit.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

final class UsersLoaded extends UsersState {
  final List<User> users;
  final List<Company> companies;
  UsersLoaded({required this.users, required this.companies});
}

final class UsersError extends UsersState {
  final String message;
  UsersError({required this.message});
}
