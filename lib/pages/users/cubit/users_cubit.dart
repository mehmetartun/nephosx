import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/company.dart';
import '../../../model/enums.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final DatabaseRepository databaseRepository;
  final User? user;
  UsersCubit(this.databaseRepository, this.user) : super(UsersInitial());

  List<User> users = [];
  List<Company> companies = [];

  void init() async {
    if (user?.type == UserType.admin) {
      companies = await databaseRepository.getCompanies();
      users = await databaseRepository.getUsers();
      emit(UsersLoaded(users: users, companies: companies));
    } else if (user?.type == UserType.corporate) {
      companies = await databaseRepository.getCompanies();
      users = await databaseRepository.getUsers(companyId: user!.companyId);
      emit(UsersLoaded(users: users, companies: [user!.company!]));
    } else {
      emit(UsersError(message: "User is not admin"));
    }
  }

  void updateUser(Company company, User u) async {
    emit(UsersInitial());
    await databaseRepository.updateDocument(
      docPath: 'users/${u.uid}',
      data: {"company_id": company.id, 'type': 'corporate'},
    );
    init();
  }
}
