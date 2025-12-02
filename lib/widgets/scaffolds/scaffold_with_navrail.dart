import 'package:nephosx/blocs/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/enums.dart';
import '../brightness_selector.dart';
import '../top_bar.dart';
import '../user_profile_card.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavRail extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavRail].
  const ScaffoldWithNavRail({
    required this.navigationShell,
    Key? key,
    required this.width,
    this.narrow = false,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavRail'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;
  final double width;
  final bool narrow;

  // #docregion configuration-custom-shell
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      title: Text('Drinks Diary'),
      centerTitle: true,
      actions: [
        // TextButton(child: Text("About"), onPressed: () {}),
        // TextButton(child: Text("Help"), onPressed: () {}),
        // TextButton(child: Text("Settings"), onPressed: () {}),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: FittedBox(child: UserProfileCard()),
        ),
      ],
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        // appBar: appBar,
        appBar: TopBar(title: 'Nephos X'),
        primary: true,
        // The StatefulNavigationShell from the associated StatefulShellRoute is
        // directly passed as the body of the Scaffold.
        body: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: NavigationRail(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerLow,
                // labelType: NavigationRailLabelType.all,
                extended: ResponsiveBreakpoints.of(context).largerThan(TABLET),
                // Here, the items of BottomNavigationBar are hard coded. In a real
                // world scenario, the items would most likely be generated from the
                // branches of the shell route, which can be fetched using
                // `navigationShell.route.branches`.
                destinations: <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.people),
                    label: Text('Users'),
                    disabled:
                        BlocProvider.of<AuthenticationBloc>(
                          context,
                        ).user?.type ==
                        UserType.public,
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.domain),
                    label: Text('Companies'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.dns),
                    label: Text('Datacenters'),
                    disabled:
                        BlocProvider.of<AuthenticationBloc>(
                          context,
                        ).user?.type ==
                        UserType.public,
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.money),
                    label: Text('Market'),
                  ),
                  // NavigationRailDestination(
                  //   icon: Icon(Icons.calendar_month),
                  //   label: Text('Diary'),
                  // ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                  // NavigationRailDestination(
                  //   icon: Icon(Icons.input),
                  //   label: Text('data'),
                  // ),
                ],
                selectedIndex: navigationShell.currentIndex,
                // Navigate to the current location of the branch at the provided index
                // when tapping an item in the BottomNavigationBar.
                onDestinationSelected: (int index) =>
                    navigationShell.goBranch(index),
                trailing: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
                        child: Text(
                          "${BlocProvider.of<AuthenticationBloc>(context).user?.type?.title} User",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
                        child: BrightnessSelector(
                          shouldPop: false,
                          narrow: narrow,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: narrow
                            ? IconButton(
                                icon: Icon(Icons.logout),
                                onPressed: () {
                                  BlocProvider.of<AuthenticationBloc>(
                                    context,
                                  ).add(AuthenticationEventSignOut());
                                },
                              )
                            : FilledButton.tonalIcon(
                                icon: Icon(Icons.logout),
                                label: Text("Sign Out"),
                                onPressed: () {
                                  BlocProvider.of<AuthenticationBloc>(
                                    context,
                                  ).add(AuthenticationEventSignOut());
                                },
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Copyright 2025 NephosX',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: navigationShell),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   // Here, the items of BottomNavigationBar are hard coded. In a real
        //   // world scenario, the items would most likely be generated from the
        //   // branches of the shell route, which can be fetched using
        //   // `navigationShell.route.branches`.
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Documents'),
        //     BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings),
        //       label: 'Settings',
        //     ),
        //   ],
        //   currentIndex: navigationShell.currentIndex,
        //   // Navigate to the current location of the branch at the provided index
        //   // when tapping an item in the BottomNavigationBar.
        //   onTap: (int index) => navigationShell.goBranch(index),
        // ),
      ),
    );
  }
}
