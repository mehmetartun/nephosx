part of 'companies_cubit.dart';

sealed class CompaniesState {}

final class CompaniesInitial extends CompaniesState {}

final class CompaniesLoaded extends CompaniesState {
  final List<Company> companies;
  CompaniesLoaded({required this.companies});
}

final class CompaniesError extends CompaniesState {
  final String message;
  CompaniesError({required this.message});
}

final class CompaniesAssign extends CompaniesState {
  final List<Company> companies;
  final User user;
  final Request? request;
  CompaniesAssign({required this.companies, required this.user, this.request});
}

final class CompaniesEditCompany extends CompaniesState {
  final Company company;
  final List<User> users;

  CompaniesEditCompany({required this.company, required this.users});
}
