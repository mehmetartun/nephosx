import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import 'brightness_selector.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                Text(
                  'Main Drawer',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (BlocProvider.of<AuthenticationBloc>(context).user != null)
                  Text(BlocProvider.of<AuthenticationBloc>(context).user!.uid),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: FilledButton(
              child: Text("Sign out"),
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<AuthenticationBloc>(
                  context,
                ).add(AuthenticationEventSignOut());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BrightnessSelector(),
          ),
        ],
      ),
    );
  }
}
