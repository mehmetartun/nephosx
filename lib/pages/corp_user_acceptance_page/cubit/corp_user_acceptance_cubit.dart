import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/model/invitaton.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../repositories/database/database.dart';

part 'corp_user_acceptance_state.dart';

class CorpUserAcceptanceCubit extends Cubit<CorpUserAcceptanceState> {
  CorpUserAcceptanceCubit({
    required this.authenticationBloc,
    required this.databaseRepository,
  }) : super(CorpUserAcceptanceInitial());

  final AuthenticationBloc authenticationBloc;
  final DatabaseRepository databaseRepository;

  Invitation? invitation;

  init({String? id}) async {
    if (id == null) {
      emit(
        CorpUserAcceptanceError(
          title: "Error",
          message: "No invitation id found",
        ),
      );
    }

    emit(CorpUserAcceptanceLoading());
    invitation = await databaseRepository.getInvitation(id!);
    if (invitation == null) {
      emit(
        CorpUserAcceptanceError(
          title: "Error",
          message: "Invitation not found",
        ),
      );
      return;
    }
    if (invitation!.status == InvitationStatus.accepted) {
      emit(
        CorpUserAcceptanceSuccess(
          title: "Success",
          message: "Invitation already accepted",
        ),
      );
      return;
    }
    if (invitation!.status == InvitationStatus.rejected) {
      emit(
        CorpUserAcceptanceSuccess(
          title: "Rejected",
          message: "Invitation already rejected",
        ),
      );
      return;
    }
    if (invitation!.status == InvitationStatus.expired) {
      emit(
        CorpUserAcceptanceSuccess(
          title: "Expired",
          message:
              "Invitation already expired. Please ask your administrator to resend the invitation.",
        ),
      );
    }
    emit(CorpUserAcceptanceLoaded(invitation: invitation!));
    return;
  }

  reject() async {
    emit(CorpUserAcceptanceLoading());
    if (invitation != null) {
      await databaseRepository.updateDocument(
        docPath: "invitations/${invitation!.id}",
        data: {"status": InvitationStatus.rejected.name},
      );
    }
  }

  accept(String password) async {
    emit(CorpUserAcceptanceLoading());
    if (invitation != null) {
      await databaseRepository.updateDocument(
        docPath: "invitations/${invitation!.id}",
        data: {"status": InvitationStatus.accepted.name},
      );
    }
    authenticationBloc.add(
      AuthenticationEventCreateNewUserWithEmailAndPassword(
        email: invitation!.email,
        password: password,
      ),
    );
  }
}
