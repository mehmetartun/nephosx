import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/company.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final DatabaseRepository databaseRepository;
  UsersCubit(this.databaseRepository) : super(UsersInitial());

  List<User> users = [];
  List<Company> companies = [];

  void init() async {
    companies = await databaseRepository.getCompanies();
    users = await databaseRepository.getUsers();
    emit(UsersLoaded(users: users, companies: companies));
  }

  void updateUser(Company company, User user) async {
    emit(UsersInitial());
    await databaseRepository.updateDocument(
      docPath: 'users/${user.uid}',
      data: {"company_id": company.id},
    );
    init();
  }
}
