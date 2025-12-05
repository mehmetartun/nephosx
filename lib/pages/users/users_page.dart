import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/pages/users/views/users_loading_view.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../repositories/database/database.dart';
import '../../widgets/views/error_view.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/users_cubit.dart';
import 'views/users_view.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UsersCubit cubit = UsersCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
      BlocProvider.of<AuthenticationBloc>(context).user,
    )..init();

    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          switch (state) {
            case UsersError _:
              return ErrorView(title: "Users Error", message: state.message);
            case UsersInitial _:
              return UsersLoadingView();
            case UsersLoaded _:
              return UsersView(
                users: state.users,
                companies: state.companies,
                onUpdateUser: cubit.updateUser,
              );
          }
        },
      ),
    );
  }
}
