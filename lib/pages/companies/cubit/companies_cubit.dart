import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/company.dart';
import '../../../repositories/database/database.dart';

part 'companies_state.dart';

class CompaniesCubit extends Cubit<CompaniesState> {
  final DatabaseRepository databaseRepository;
  CompaniesCubit(this.databaseRepository) : super(CompaniesInitial());

  List<Company> companies = [];

  void init() async {
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
