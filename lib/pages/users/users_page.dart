import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/database/database.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/users_cubit.dart';
import 'views/users_view.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UsersCubit cubit = UsersCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
    )..init();

    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          switch (state) {
            case UsersInitial _:
              return LoadingView(title: "Loading users");
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
