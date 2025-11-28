import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appUser = BlocProvider.of<AuthenticationBloc>(context).user;

    // final imageBytes = _parseBase64Image(appUser?.photoBase64);
    final imageBytes = null;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: imageBytes != null ? MemoryImage(imageBytes) : null,
          child: imageBytes == null ? Icon(Icons.person, size: 20) : null,
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appUser?.displayName ?? 'Guest',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              appUser?.email ?? 'Not logged in',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),

        // SignOutButton(),
      ],
    );
  }
}
