import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../repositories/database/database.dart';
import '../../widgets/views/error_view.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/profile_cubit.dart';
import 'views/profile_edit_view.dart';
import 'views/profile_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        uid: BlocProvider.of<AuthenticationBloc>(context).user?.uid,
        databaseRepository: RepositoryProvider.of<DatabaseRepository>(context),
      )..init(),

      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          switch (state) {
            case ProfileInitial _:
              return LoadingView(
                title: 'Profile',
                message: 'Loading Profile...',
              );
            case ProfileLoading _:
              return LoadingView(
                title: 'Profile',
                message: 'Loading Profile...',
              );
            case ProfileLoaded _:
              return ProfileView(
                user: context.read<ProfileCubit>().user!,
                editProfile: context.read<ProfileCubit>().editProfile,
              );
            case ProfileEdit _:
              return ProfileEditView(
                user: state.user,
                onUpdate: context.read<ProfileCubit>().updateUser,
                onCancel: context.read<ProfileCubit>().cancelEditUser,
              );
            case ProfileError _:
              return ErrorView(
                title: 'Profile',
                message:
                    'An error occurred while loading profile. ${state.errorMessage}',
              );
          }
        },
      ),
    );
  }
}
