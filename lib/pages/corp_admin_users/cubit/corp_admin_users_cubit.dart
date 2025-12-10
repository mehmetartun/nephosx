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

  addInvitation({required String email, required String displayName}) async {
    emit(CorpAdminUsersInitial());
    try {
      await addInvitationFunction.call({
        'email': email,
        'displayName': displayName,
        'companyId': user!.companyId,
        'companyName': user!.company!.name,
        'message':
            'Dear $displayName, you have been invited'
            ' to join ${user!.company!.name} on the NephosX platform. '
            'Click on the link below to join the platform. <a href="https://nephosx.com">NephosX</a>',
      });
    } catch (e) {
      emit(CorpAdminUsersError(error: e.toString()));
    }
    init();
    // emit(CorpAdminUsersLoaded(users: users, invitations: invitations));
  }
}
