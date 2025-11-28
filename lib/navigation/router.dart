import 'package:coach/pages/consumption_entry/consumption_entry_page.dart';
import 'package:coach/pages/data_entry/data_entry_page.dart';
import 'package:coach/pages/sign_in/sign_in_page.dart';
import 'package:go_router/go_router.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../pages/generic_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/splash_page.dart';
import '../pages/statistics/statistics_page.dart';
import '../widgets/scaffolds/responsive_scaffold.dart';
import 'my_navigator_route.dart';

import 'package:flutter/material.dart';

import 'refresh_listenable.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

class NestedRouter {
  NestedRouter({required this.authenticationBloc});

  final AuthenticationBloc authenticationBloc;

  GoRouter get router => _router;
  GoRouter get simpleRouter => _simpleRouter;

  late final GoRouter _simpleRouter = GoRouter(
    initialLocation: MyNavigatorRoute.consumptionEntry.path,
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
    redirect: (context, state) {
      switch (authenticationBloc.state) {
        case AuthenticationStateSignedIn _:
          if (state.matchedLocation.contains(MyNavigatorRoute.signIn.path)) {
            return MyNavigatorRoute.consumptionEntry.path;
            // return null;
          } else {
            return null;
          }
        default:
          if (state.matchedLocation.contains(MyNavigatorRoute.signIn.path)) {
            return null;
          } else {
            return MyNavigatorRoute.signIn.path;
          }
      }
    },
    routes: [
      GoRoute(
        path: MyNavigatorRoute.consumptionEntry.path,
        name: MyNavigatorRoute.consumptionEntry.name,
        builder: (context, state) => DataEntryPage(),
      ),
      GoRoute(
        path: MyNavigatorRoute.signIn.path,
        name: MyNavigatorRoute.signIn.name,
        builder: (context, state) => SignInPage(),
      ),
    ],
  );

  late final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    // navigatorKey: _rootNavigatorKey,
    initialLocation: "/stats",
    redirect: (BuildContext context, GoRouterState state) {
      if (state.matchedLocation == MyNavigatorRoute.splash.path) {
        return null;
      }

      switch (authenticationBloc.state) {
        case AuthenticationStateSignedIn _:
          if (state.matchedLocation.contains(MyNavigatorRoute.signIn.path)) {
            // return MyNavigatorRoute.dataEntryTop.path;
            // return MyNavigatorRoute.consumptionEntry.path;
            return "/stats";
            // return null;
          } else {
            return null;
          }

        default:
          if (state.matchedLocation.contains(MyNavigatorRoute.signIn.path)) {
            return null;
          } else {
            return MyNavigatorRoute.signIn.path;
          }
      }
    },
    routes: <RouteBase>[
      GoRoute(
        path: MyNavigatorRoute.splash.path,
        name: MyNavigatorRoute.splash.name,
        builder: (BuildContext context, GoRouterState state) => SplashPage(),
      ),
      GoRoute(
        path: MyNavigatorRoute.home.path,
        name: MyNavigatorRoute.home.name,
        builder: (BuildContext context, GoRouterState state) =>
            const GenericPage(),
        routes: [
          StatefulShellRoute.indexedStack(
            // parentNavigatorKey: _rootNavigatorKey,
            builder:
                (
                  BuildContext context,
                  GoRouterState state,
                  StatefulNavigationShell navigationShell,
                ) {
                  // Return the widget that implements the custom shell (in this case
                  // using a BottomNavigationBar). The StatefulNavigationShell is passed
                  // to be able access the state of the shell and to navigate to other
                  // branches in a stateful way.
                  return ResponsiveScaffold(navigationShell: navigationShell);
                },
            // #enddocregion configuration-builder
            // #docregion configuration-branches
            branches: <StatefulShellBranch>[
              // The route branch for the first tab of the bottom navigation bar.
              StatefulShellBranch(
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the first tab of the
                    // bottom navigation bar.
                    // name: "documents",
                    path: MyNavigatorRoute.stats.path,
                    name: MyNavigatorRoute.stats.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const StatisticsPage(),
                    // routes: <RouteBase>[
                    //   // The details screen to display stacked on navigator of the
                    //   // first tab. This will cover screen A but not the application
                    //   // shell (bottom navigation bar).
                    //   GoRoute(
                    //     // parentNavigatorKey: _sectionANavigatorKey,
                    //     path: 'details',
                    //     builder: (BuildContext context, GoRouterState state) =>
                    //         const DetailsScreen(label: 'A'),
                    //   ),
                    // ],
                  ),
                ],
                // To enable preloading of the initial locations of branches, pass
                // 'true' for the parameter `preload` (false is default).
              ),
              // #enddocregion configuration-branches

              // The route branch for the second tab of the bottom navigation bar.
              StatefulShellBranch(
                // It's not necessary to provide a navigatorKey if it isn't also
                // needed elsewhere. If not provided, a default key will be used.
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the second tab of the
                    // bottom navigation bar.
                    // name: "convertPdf",
                    path: MyNavigatorRoute.day.path,
                    name: MyNavigatorRoute.day.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const ConsumptionPage(),
                    // routes: <RouteBase>[
                    //   GoRoute(
                    //     name: 'templateManagement',
                    //     path: 'templateManagement',
                    //     builder: (BuildContext context, GoRouterState state) =>
                    //         const TemplateManagementPage(),
                    //   ),
                    // ],
                  ),
                ],
              ),

              // The route branch for the third tab of the bottom navigation bar.
              StatefulShellBranch(
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the third tab of the
                    // bottom navigation bar.
                    // name: "settings",
                    path: MyNavigatorRoute.profile.path,
                    name: MyNavigatorRoute.profile.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const ProfilePage(),
                    // routes: <RouteBase>[
                    //   GoRoute(
                    //     path: 'changeUserImage',
                    //     builder: (BuildContext context, GoRouterState state) =>
                    //         Container(),
                    //   ),
                    // ],
                  ),
                ],
              ),
              // StatefulShellBranch(
              //   // navigatorKey: _sectionANavigatorKey,
              //   routes: <RouteBase>[
              //     GoRoute(
              //       // The screen to display as the root in the third tab of the
              //       // bottom navigation bar.
              //       // name: "settings",
              //       path: MyNavigatorRoute.dataEntry.path,
              //       name: MyNavigatorRoute.dataEntry.name,
              //       builder: (BuildContext context, GoRouterState state) =>
              //           DataEntryPage(),
              //       routes: [
              //         GoRoute(
              //           // The screen to display as the root in the third tab of the
              //           // bottom navigation bar.
              //           // name: "settings",
              //           path: ":itemId",

              //           builder: (BuildContext context, GoRouterState state) =>
              //               DataEntryPage(
              //                 itemId: state.pathParameters['itemId'],
              //               ),
              //           // routes: <RouteBase>[
              //           //   GoRoute(
              //           //     path: 'changeUserImage',
              //           //     builder: (BuildContext context, GoRouterState state) =>
              //           //         Container(),
              //           //   ),
              //           // ],
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // StatefulShellBranch(
              //   routes: <RouteBase>[
              //     GoRoute(
              //       // name: 'templateManagement',
              //       path: RouteNames.templateManagement,
              //       builder: (BuildContext context, GoRouterState state) =>
              //           const TemplateManagementPage(),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: MyNavigatorRoute.signIn.path,

        name: MyNavigatorRoute.signIn.name,
        builder: (BuildContext context, GoRouterState state) => SignInPage(),
      ),
      // GoRoute(
      //   path: MyNavigatorRoute.dataEntryTop.path,
      //   name: MyNavigatorRoute.dataEntryTop.name,
      //   builder: (BuildContext context, GoRouterState state) => DataEntryPage(),
      // ),
      // GoRoute(
      //   path: MyNavigatorRoute.consumptionEntry.path,
      //   name: MyNavigatorRoute.consumptionEntry.name,
      //   builder: (BuildContext context, GoRouterState state) =>
      //       ConsumptionPage(),
      // ),

      // #docregion configuration-builder
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   final bool isAuthenticated =
    //       authenticationBloc.state is AuthenticationAuthenticated;

    //   final bool isAuthenticating =
    //       state.matchedLocation == '/auth' ||
    //       state.matchedLocation == '/auth/sign-in' ||
    //       state.matchedLocation == '/auth/sign-up' ||
    //       state.matchedLocation == '/auth/reset-password';

    //   if (!isAuthenticated && !isAuthenticating) {
    //     // If not authenticated and not already on an auth path, redirect to /auth
    //     return '/auth';
    //   } else if (isAuthenticated && isAuthenticating) {
    //     // If authenticated and on an auth path, redirect to home
    //     return '/';
    //   }

    //   // No redirect needed
    //   return null;
    // },
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
  );
}
