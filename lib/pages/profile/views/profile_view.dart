import 'package:coach/blocs/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

import '../../../model/user.dart';
import '../../../widgets/user_card.dart';

class ProfileView extends StatelessWidget {
  final User user;
  final void Function() editProfile;
  const ProfileView({super.key, required this.user, required this.editProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: editProfile),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(
                context,
              ).add(AuthenticationEventSignOut());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [UserCard(user: user, minRadius: 70)]),
      ),
    );
  }
}
