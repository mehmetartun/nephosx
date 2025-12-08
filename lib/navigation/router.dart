import 'package:nephosx/pages/sign_in/sign_in_page.dart';
import 'package:go_router/go_router.dart';
import 'package:nephosx/pages/transactions/transactions_page.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../pages/admin/admin_page.dart';
import '../pages/companies/companies_page.dart';
import '../pages/datacenters/datacenters_page.dart';
import '../pages/generic_page.dart';
import '../pages/gpu_clusters/gpu_clusters_page.dart';
import '../pages/market/market_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/users/users_page.dart';
import '../theme/theme_page.dart';
import '../widgets/animation_widget.dart';
import '../widgets/scaffolds/admin_with_navrail.dart';
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
  // GoRouter get simpleRouter => _simpleRouter;

  // late final GoRouter _simpleRouter = GoRouter(
  //   initialLocation: MyNavigatorRoute.consumptionEntry.path,
  //   refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
  //   redirect: (context, state) {
  //     switch (authenticationBloc.state) {
  //       case AuthenticationStateSignedIn _:
  //         if (state.matchedLocation.contains(MyNavigatorRoute.signIn.path)) {
  //           return MyNavigatorRoute.consumptionEntry.path;
  //           // return null;
  //         } else {
  //           return null;
  //         }
  //       default:
  //         if (state.matchedLocation.contains(MyNavigatorRoute.signIn.path)) {
  //           return null;
  //         } else {
  //           return MyNavigatorRoute.signIn.path;
  //         }
  //     }
  //   },
  //   routes: [
  //     GoRoute(
  //       path: MyNavigatorRoute.consumptionEntry.path,
  //       name: MyNavigatorRoute.consumptionEntry.name,
  //       builder: (context, state) => DataEntryPage(),
  //     ),
  //     GoRoute(
  //       path: MyNavigatorRoute.signIn.path,
  //       name: MyNavigatorRoute.signIn.name,
  //       builder: (context, state) => SignInPage(),
  //     ),
  //   ],
  // );

  late final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    // navigatorKey: _rootNavigatorKey,
    initialLocation: "/market",
    redirect: (BuildContext context, GoRouterState state) {
      print('Mathced Location ${state.matchedLocation}');
      print('Uri ${state.uri.toString()}');
      print('Path ${state.path}');
      print('Full Path ${state.fullPath}');

      if (state.matchedLocation == MyNavigatorRoute.splash.path) {
        return null;
      }

      switch (authenticationBloc.state) {
        case AuthenticationStateSignedIn _:
          if (state.matchedLocation.contains(MyNavigatorRoute.signIn.path)) {
            // return MyNavigatorRoute.dataEntryTop.path;
            // return MyNavigatorRoute.consumptionEntry.path;

            return "/market";
            // return null;
          } else {
            print(state.matchedLocation);
            return null;
          }
        case AuthenticationStateUnkown _:
          authenticationBloc.add(
            AuthenticationDestinationAfterSignInEvent(
              destination: state.matchedLocation,
            ),
          );
          // return "/splash";
          if (state.matchedLocation.contains(MyNavigatorRoute.signIn.path)) {
            return null;
          } else {
            return MyNavigatorRoute.signIn.path;
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
        builder: (BuildContext context, GoRouterState state) =>
            ComputerGridAnimation(),
      ),
      GoRoute(
        path: MyNavigatorRoute.theme.path,
        name: MyNavigatorRoute.theme.name,
        builder: (BuildContext context, GoRouterState state) => ThemePage(),
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
                  return ResponsiveScaffold(navigationShell: navigationShell);
                },
            branches: <StatefulShellBranch>[
              StatefulShellBranch(
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    path: MyNavigatorRoute.users.path,
                    name: MyNavigatorRoute.users.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const UsersPage(),
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
                    path: MyNavigatorRoute.companies.path,
                    name: MyNavigatorRoute.companies.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const CompaniesPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                // It's not necessary to provide a navigatorKey if it isn't also
                // needed elsewhere. If not provided, a default key will be used.
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the second tab of the
                    // bottom navigation bar.
                    // name: "convertPdf",
                    path: MyNavigatorRoute.datacenters.path,
                    name: MyNavigatorRoute.datacenters.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const DatacentersPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                // It's not necessary to provide a navigatorKey if it isn't also
                // needed elsewhere. If not provided, a default key will be used.
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the second tab of the
                    // bottom navigation bar.
                    // name: "convertPdf",
                    path: MyNavigatorRoute.gpuClusters.path,
                    name: MyNavigatorRoute.gpuClusters.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const GpuClustersPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                // It's not necessary to provide a navigatorKey if it isn't also
                // needed elsewhere. If not provided, a default key will be used.
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the second tab of the
                    // bottom navigation bar.
                    // name: "convertPdf",
                    path: MyNavigatorRoute.market.path,
                    name: MyNavigatorRoute.market.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const MarketPage(),
                  ),
                ],
              ),
              // StatefulShellBranch(
              //   // It's not necessary to provide a navigatorKey if it isn't also
              //   // needed elsewhere. If not provided, a default key will be used.
              //   // navigatorKey: _sectionANavigatorKey,
              //   routes: <RouteBase>[
              //     GoRoute(
              //       // The screen to display as the root in the second tab of the
              //       // bottom navigation bar.
              //       // name: "convertPdf",
              //       path: MyNavigatorRoute.gpus.path,
              //       name: MyNavigatorRoute.gpus.name,
              //       builder: (BuildContext context, GoRouterState state) =>
              //           const GpuPage(),
              //     ),
              //   ],
              // ),

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
              StatefulShellBranch(
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the third tab of the
                    // bottom navigation bar.
                    // name: "settings",
                    path: MyNavigatorRoute.transactions.path,
                    name: MyNavigatorRoute.transactions.name,
                    builder: (BuildContext context, GoRouterState state) =>
                        const TransactionsPage(),
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
              StatefulShellBranch(
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  StatefulShellRoute.indexedStack(
                    builder: (context, state, innerShell) {
                      return AdminWithNavrail(
                        navigationShell: innerShell,
                        width: 250,
                      );
                    },
                    branches: [
                      StatefulShellBranch(
                        routes: [
                          GoRoute(
                            // The screen to display as the root in the third tab of the
                            // bottom navigation bar.
                            // name: "settings",
                            path: MyNavigatorRoute.admin.path,
                            name: MyNavigatorRoute.admin.name,
                            builder:
                                (BuildContext context, GoRouterState state) =>
                                    const AdminPage(),
                          ),
                        ],
                      ),
                    ],
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
