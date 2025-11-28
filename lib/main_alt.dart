import 'package:coach/blocs/notifications/bloc/notifications_bloc.dart';
import 'package:coach/firebase_options.dart';
import 'package:coach/pages/generic_page.dart';
import 'package:coach/repositories/authentication/authentication_repository.dart';
import 'package:coach/theme/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'pages/data_entry/data_entry_page.dart';
import 'pages/info_page.dart';
import 'repositories/database/database.dart';
import 'theme/theme.dart';

void main() async {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',

      routerConfig: GoRouter(
        initialLocation: "/",
        debugLogDiagnostics: true,
        // errorPageBuilder: (context, state) {
        //   return MaterialPage(
        //     child: InfoPage(title: "Error", content: state.error.toString()),
        //   );
        // },
        // errorBuilder: (context, state) =>
        //     InfoPage(title: "Error", content: state.error.toString()),
        onException: (context, state, router) {
          return router.go(
            "/404",
            extra: {
              'route': state.uri.toString(),
              'error': state.error.toString(),
            },
          );
        },
        routes: [
          GoRoute(
            path: "/",
            name: "home",
            builder: (context, state) => InfoPage(title: "/"),
            routes: [
              GoRoute(
                path: "one",
                name: "one",
                builder: (context, state) => InfoPage(title: "/one"),
              ),
              GoRoute(
                path: "two",
                name: "two",
                builder: (context, state) => InfoPage(title: "/two"),
              ),
            ],
          ),
          GoRoute(
            path: "/404",
            name: "Error",
            builder: (context, state) =>
                InfoPage(title: "/404", content: state.extra.toString()),
          ),
        ],
      ),
    );
  }
}
