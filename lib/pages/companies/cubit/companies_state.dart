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
