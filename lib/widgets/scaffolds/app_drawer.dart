import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../navigation/my_navigator_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current route to highlight the active item
    final String currentLocation = GoRouterState.of(context).matchedLocation;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'PDF GURU',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: currentLocation == '/',
            onTap: () {
              // Close the drawer first
              Navigator.of(context).pop();
              // Navigate to the route
              context.goNamed(MyNavigatorRoute.home.name);
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.picture_as_pdf),
          //   title: const Text('PDF Loader'),
          //   selected: currentLocation == '/loadpdf',
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     context.go('/loadpdf');
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.folder),
          //   title: const Text('Directory'),
          //   selected: currentLocation == '/directory',
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     context.go('/directory');
          //   },
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              // Close the drawer
              Navigator.of(context).pop();
              // Dispatch the sign out event
              context.read<AuthenticationBloc>().add(
                AuthenticationEventSignOut(),
              );
            },
          ),
        ],
      ),
    );
  }
}
