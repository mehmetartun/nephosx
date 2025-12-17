import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nephosx/pages/corp_user_acceptance_page/cubit/corp_user_acceptance_cubit.dart';
import 'package:nephosx/pages/corp_user_acceptance_page/views/corp_user_acceptance_error_view.dart';
import 'package:nephosx/pages/corp_user_acceptance_page/views/corp_user_acceptance_loading_view.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../repositories/database/database.dart';
import 'views/corp_user_acceptance_view.dart';

class CorpUserAcceptancePage extends StatelessWidget {
  const CorpUserAcceptancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final invitationId = GoRouter.of(context).state.uri.queryParameters["id"];
    print(invitationId);

    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    final databaseRepository = RepositoryProvider.of<DatabaseRepository>(
      context,
    );
    final corpUserAcceptanceCubit = CorpUserAcceptanceCubit(
      authenticationBloc: authenticationBloc,
      databaseRepository: databaseRepository,
    )..init(id: invitationId);
    return BlocProvider(
      create: (context) => corpUserAcceptanceCubit,
      child: BlocBuilder<CorpUserAcceptanceCubit, CorpUserAcceptanceState>(
        builder: (context, state) {
          switch (state) {
            case CorpUserAcceptanceLoaded _:
              return CorpUserAcceptanceView(
                invitation: state.invitation,
                onReject: () {
                  corpUserAcceptanceCubit.reject();
                },
              );
            case CorpUserAcceptanceError _:
              return CorpUserAcceptanceErrorView(
                title: state.title,
                message: state.message,
              );
            case CorpUserAcceptanceSuccess _:
              return CorpUserAcceptanceErrorView(
                title: state.title,
                message: state.message,
              );
            default:
              return CorpUserAcceptanceLoadingView(title: 'Loading');
          }
        },
      ),
    );
  }
}
