import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'scaffold_with_navbar.dart';
import 'scaffold_with_navrail.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return ResponsiveValue<Widget>(
      context,
      conditionalValues: [
        Condition.equals(
          name: 'MOBILE',
          value: ScaffoldWithNavBar(navigationShell: navigationShell),
        ),
        Condition.equals(
          name: 'TABLET',
          value: ScaffoldWithNavRail(
            navigationShell: navigationShell,
            width: 100,
          ),
        ),
        Condition.equals(
          name: 'DESKTOP',
          value: ScaffoldWithNavRail(
            navigationShell: navigationShell,
            width: 250,
          ),
        ),
      ],
      defaultValue: ScaffoldWithNavRail(
        navigationShell: navigationShell,
        width: 250,
      ),
    ).value;
  }
}
