import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/company.dart';
import '../../../model/enums.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'companies_state.dart';

class CompaniesCubit extends Cubit<CompaniesState> {
  final DatabaseRepository databaseRepository;
  CompaniesCubit(this.databaseRepository, this.user)
    : super(CompaniesInitial());

  User? user;
  List<Company> companies = [];

  void init() async {
    if (user == null) {
      emit(CompaniesError(message: "User is null"));
      return;
    }
    if (user!.type != UserType.admin) {
      emit(CompaniesError(message: "User is not admin"));
      return;
    }
    companies = await databaseRepository.getCompanies();
    emit(CompaniesLoaded(companies: companies));
  }

  void addCompany(Map<String, dynamic> data) async {
    await databaseRepository.addDocument(
      collectionPath: 'companies',
      data: data,
    );
    init();
  }
}
