import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/blocs/authentication/authentication_bloc.dart';
import 'package:nephosx/repositories/database/database.dart';

import '../../model/user.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/corp_admin_users_cubit.dart';
import 'views/corp_admin_users_error_view.dart';
import 'views/corp_admin_users_view.dart';

class CorpAdminUsersPage extends StatelessWidget {
  const CorpAdminUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = BlocProvider.of<AuthenticationBloc>(context).user;
    DatabaseRepository databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    CorpAdminUsersCubit cubit = CorpAdminUsersCubit(user, databaseRepository)
      ..init();
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<CorpAdminUsersCubit, CorpAdminUsersState>(
        builder: (context, state) {
          switch (state) {
            case CorpAdminUsersError _:
              return CorpAdminUsersErrorView(
                message: state.error,
                onCancel: () {
                  cubit.onCancel();
                },
              );
            case CorpAdminUsersInitial _:
              return LoadingView(title: "Loading Users");
            case CorpAdminUsersLoaded _:
              return CorpAdminUsersView(
                users: state.users,
                invitations: state.invitations,
                addInvitation: cubit.addInvitation,
              );
          }
        },
      ),
    );
  }
}
