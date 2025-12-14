import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:nephosx/model/invitaton.dart';
import 'package:nephosx/repositories/database/database.dart';

import '../../../model/user.dart';

part 'corp_admin_users_state.dart';

class CorpAdminUsersCubit extends Cubit<CorpAdminUsersState> {
  CorpAdminUsersCubit(this.user, this.databaseRepository)
    : super(CorpAdminUsersInitial());
  final User? user;
  List<User> users = [];
  List<Invitation> invitations = [];
  final DatabaseRepository databaseRepository;
  final HttpsCallable addInvitationFunction = FirebaseFunctions.instance
      .httpsCallable('corpAdminAddInvitation');

  init() async {
    users = await databaseRepository.getUsers(companyId: user!.companyId);
    invitations = await databaseRepository.getInvitations(
      companyId: user!.companyId,
    );
    emit(CorpAdminUsersLoaded(users: users, invitations: invitations));
  }

  onCancel() async {
    emit(CorpAdminUsersInitial());
    init();
  }

  updateUser({required User user}) async {}

  addInvitation({required String email, required String displayName}) async {
    emit(CorpAdminUsersInitial());
    try {
      await addInvitationFunction.call({
        'email': email,
        'displayName': displayName,
        'companyId': user!.companyId,
        'companyName': user!.company!.name,
      });
    } catch (e) {
      emit(CorpAdminUsersError(error: e.toString()));
    }
    init();
    // emit(CorpAdminUsersLoaded(users: users, invitations: invitations));
  }
}
