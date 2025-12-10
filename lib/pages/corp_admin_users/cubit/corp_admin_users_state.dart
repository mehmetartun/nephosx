part of 'corp_admin_users_cubit.dart';

@immutable
sealed class CorpAdminUsersState {}

final class CorpAdminUsersInitial extends CorpAdminUsersState {}

final class CorpAdminUsersLoaded extends CorpAdminUsersState {
  final List<User> users;
  final List<Invitation> invitations;
  CorpAdminUsersLoaded({required this.users, required this.invitations});
}

final class CorpAdminUsersError extends CorpAdminUsersState {
  final String error;
  CorpAdminUsersError({required this.error});
}
