import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';

import 'pages/info_page.dart';

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
