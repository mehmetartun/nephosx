// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  // final AppBar appBar;

  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    Key? key,
    // required this.appBar,
    required this.navigationShell,
    this.appBar,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;
  final AppBar? appBar;

  // #docregion configuration-custom-shell
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        // The StatefulNavigationShell from the associated StatefulShellRoute is
        // directly passed as the body of the Scaffold.
        // appBar: appBar,
        // appBar: _appBar,
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          // Here, the items of BottomNavigationBar are hard coded. In a real
          // world scenario, the items would most likely be generated from the
          // branches of the shell route, which can be fetched using
          // `navigationShell.route.branches`.
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Diary',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            // BottomNavigationBarItem(icon: Icon(Icons.input), label: 'Data'),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.dashboard_outlined),
            //   label: 'Templates',
            // ),
          ],
          currentIndex: navigationShell.currentIndex,
          // Navigate to the current location of the branch at the provided index
          // when tapping an item in the BottomNavigationBar.
          onTap: (int index) {
            navigationShell.goBranch(index);
          },
        ),
      ),
    );
  }
}
