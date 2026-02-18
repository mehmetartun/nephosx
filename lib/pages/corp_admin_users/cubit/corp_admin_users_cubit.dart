import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:nephosx/model/invitaton.dart';
import 'package:nephosx/repositories/database/database.dart';

import '../../../model/company.dart';
import '../../../model/user.dart';

part 'corp_admin_users_state.dart';

class CorpAdminUsersCubit extends Cubit<CorpAdminUsersState> {
  CorpAdminUsersCubit(this.user, this.databaseRepository)
    : super(CorpAdminUsersInitial());
  final User? user;
  Company? company;
  List<User> users = [];
  List<Invitation> invitations = [];
  final DatabaseRepository databaseRepository;
  final HttpsCallable addInvitationFunction = FirebaseFunctions.instance
      .httpsCallable('company-corpAdminAddInvitation');

  init() async {
    users = await databaseRepository.getUsers(companyId: user!.companyId);
    company = await databaseRepository.getCompany(user!.companyId!);
    invitations = await databaseRepository.getInvitations(
      companyId: user!.companyId,
    );
    emit(
      CorpAdminUsersLoaded(
        users: users,
        invitations: invitations,
        primaryContactId: company!.primaryContactId,
      ),
    );
  }

  onCancel() async {
    emit(CorpAdminUsersInitial());
    init();
  }

  updateUser({required User user}) async {
    emit(CorpAdminUsersInitial());
    try {
      await databaseRepository.updateDocument(
        docPath: "users/${user.uid}",
        data: user.toJson(),
      );
    } catch (e) {
      emit(CorpAdminUsersError(error: e.toString()));
    }
    init();
  }

  addInvitation({required String email, required String displayName}) async {
    emit(CorpAdminUsersInitial());
    try {
      await addInvitationFunction.call({
        'email': email,
        'displayName': displayName,
        'companyId': user!.companyId,
        'companyName': user!.company!.name,
      });
      init();
    } catch (e) {
      emit(CorpAdminUsersError(error: e.toString()));
    }

    // emit(CorpAdminUsersLoaded(users: users, invitations: invitations));
  }

  onSetPrimaryContact({required String uid}) async {
    emit(CorpAdminUsersInitial());
    try {
      await databaseRepository.updateDocument(
        docPath: "companies/${user!.companyId}",
        data: {'primary_contact_id': uid},
      );
    } catch (e) {
      emit(CorpAdminUsersError(error: e.toString()));
    }
    init();
  }
}
