import 'package:nephosx/blocs/consumption/consumption_bloc.dart';
import 'package:nephosx/blocs/notifications/bloc/notifications_bloc.dart';
import 'package:nephosx/blocs/requests/bloc/requests_bloc.dart';
import 'package:nephosx/firebase_options.dart';
import 'package:nephosx/navigation/my_navigator_route.dart';
import 'package:nephosx/repositories/authentication/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'navigation/router.dart';
import 'repositories/database/database.dart';
import 'services/platform_settings/platform_settings_service.dart';
import 'theme/cubit/theme_cubit.dart';
import 'theme/theme_black.dart';
import 'theme/util.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'widgets/views/password_secreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Future> initialize = [];
  // initialize.add(LocalStorage.instance.initialize());
  initialize.add(
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  );
  await Future.wait(initialize);
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // HttpsCallableResult res;
  // res = await FirebaseFunctions.instance.httpsCallable('helloWorld').call();
  usePathUrlStrategy();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setString("password", "123");
  var password = prefs.getString("password");
  // print(password);
  if (password == "TopSecret123") {
    runApp(const MyApp());
  } else {
    runApp(const PasswordApp());
  }
}

class PasswordApp extends StatelessWidget {
  const PasswordApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Nephos X',
      debugShowCheckedModeBanner: false,
      home: PasswordScreen(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DatabaseRepository databaseRepository =
        FirestoreDatabaseRepository.instance;

    PlatformSettingsService.instance.init(databaseRepository);

    AuthenticationRepository authenticationRepository =
        FirebaseAuthenticationRepository.instance..init(databaseRepository);
    AuthenticationBloc authenticationBloc = AuthenticationBloc(
      authenticationRepository,
      databaseRepository,
    );
    ConsumptionBloc consumptionBloc = ConsumptionBloc(databaseRepository)
      ..init();

    ThemeCubit themeCubit = ThemeCubit()
      ..changeThemeMode(ThemeCubit.savedThemeMode);

    return RepositoryProvider<DatabaseRepository>(
      create: (context) => databaseRepository,
      child: RepositoryProvider<AuthenticationRepository>(
        create: (context) => authenticationRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
              create: (context) => authenticationBloc..init(),
            ),
            BlocProvider<NotificationsBloc>(
              create: (context) => NotificationsBloc(),
            ),
            BlocProvider<ThemeCubit>(create: (context) => themeCubit),
            BlocProvider<ConsumptionBloc>(create: (context) => consumptionBloc),
            BlocProvider<RequestsBloc>(
              create: (context) =>
                  RequestsBloc(databaseRepository: databaseRepository),
            ),
          ],

          child: MyMaterialApp(),
        ),
      ),
    );
  }
}

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({super.key});

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // Register the observer to start listening to lifecycle changes

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);

  //   // Check for the transition from background to foreground
  //   if (state == AppLifecycleState.resumed && !kIsWeb) {
  //     // App is now visible and active (brought to foreground)
  //     // setState(() {
  //     //   _showSplash = true;
  //     // });
  //     BlocProvider.of<NotificationsBloc>(
  //       context,
  //     ).add(NotificationsEventShowSplash());
  //   }
  //   // You could also hide the splash if it goes to background/inactive
  //   // else if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
  //   //   // Code to ensure splash is not active if you need to manage that state
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    final goRouter = NestedRouter(
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    ).router;
    // final goRouter = NestedRouter(
    //   authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    // ).simpleRouter;

    MaterialTheme materialTheme = MaterialTheme(
      createTextTheme(context, "Noto Sans", "Noto Sans Display"),
    );
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp.router(
          title: 'Nephos X',
          debugShowCheckedModeBanner: false,
          theme: materialTheme.light(),
          darkTheme: materialTheme.dark(),
          themeMode: themeState.themeMode,
          highContrastDarkTheme: materialTheme.darkHighContrast(),
          highContrastTheme: materialTheme.lightHighContrast(),

          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          routerConfig: goRouter,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
            child: BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationStateSignedIn &&
                    state.destination != null) {
                  BlocProvider.of<AuthenticationBloc>(
                    context,
                  ).add(AuthenticationEventDestinationCleared());
                  goRouter.go(state.destination!);
                }
                if (state is AuthenticationStateSignedIn) {
                  BlocProvider.of<RequestsBloc>(
                    context,
                  ).add(RequestsEventUserChanged(state.user));
                }
              },
              child: BlocListener<NotificationsBloc, NotificationsState>(
                listener: (context, state) {
                  if (state is NotificationsShowSplashState) {
                    goRouter.pushNamed(MyNavigatorRoute.splash.name);
                  }
                },
                child: child!,
              ),
            ),
          ),
        );
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Future<UserCredential> signInWithGoogle() async {
//     // Trigger the authentication flow
//     await GoogleSignIn.instance.initialize();
//     final GoogleSignInAccount googleUser = await GoogleSignIn.instance
//         .authenticate();

//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication googleAuth = googleUser.authentication;

//     // Create a new credential
//     final credential = GoogleAuthProvider.credential(
//       idToken: googleAuth.idToken,
//     );

//     // Once signed in, return the UserCredential
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }

//   Future<UserCredential> signInWithApple() async {
//     final appleProvider = AppleAuthProvider()
//       ..addScope('email')
//       ..addScope('name'); // Request scopes for name and email

//     UserCredential userCredential;
//     if (kIsWeb) {
//       userCredential = await FirebaseAuth.instance.signInWithPopup(
//         appleProvider,
//       );
//     } else {
//       userCredential = await FirebaseAuth.instance.signInWithProvider(
//         appleProvider,
//       );
//     }

//     // --- 💡 THE CRITICAL STEP IS HERE ---
//     // The data is NOT on userCredential.user.displayName or userCredential.user.email
//     final rawUserInfo = userCredential.additionalUserInfo?.profile;

//     if (rawUserInfo != null) {
//       // 1. Get the name
//       final firstName = rawUserInfo['given_name'] as String?;
//       final lastName = rawUserInfo['family_name'] as String?;
//       final fullName = (firstName != null && lastName != null)
//           ? '$firstName $lastName'
//           : null;

//       // 2. Get the email (it can be the real one or the private relay)
//       final email = rawUserInfo['email'] as String?;

//       // Log the data to confirm it's present on the first sign-in

//       // 3. **IMMEDIATELY SAVE THIS DATA** to your database (e.g., Firestore)
//       // You should use the userCredential.user.uid as the document ID.
//       if (fullName != null || email != null) {
//         // Example of saving to Firestore/database (you need to implement this)
//         // await saveUserDataToDatabase(
//         //   uid: userCredential.user!.uid,
//         //   name: fullName,
//         //   email: email
//         // );
//       }
//     }

//     return userCredential;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 FirebaseAuth.instance.currentUser != null
//                     ? 'Logged in as ${FirebaseAuth.instance.currentUser!.email}'
//                     : 'Not logged in',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               FilledButton(
//                 child: Text("Google"),
//                 onPressed: () async {
//                   final provider = GoogleAuthProvider();
//                   if (kIsWeb) {
//                     provider
//                       ..addScope(
//                         'https://www.googleapis.com/auth/contacts.readonly',
//                       )
//                       ..setCustomParameters({'login_hint': 'email'});
//                     await FirebaseAuth.instance.signInWithPopup(provider);
//                   } else {
//                     await signInWithGoogle();
//                     // await FirebaseAuth.instance.signInWithProvider(provider);
//                   }
//                   setState(() {});
//                 },
//               ),
//               SizedBox(height: 20),
//               FilledButton(
//                 child: Text("Apple"),
//                 onPressed: () async {
//                   await signInWithApple();
//                   setState(() {});
//                 },
//               ),
//               SizedBox(height: 20),
//               if (FirebaseAuth.instance.currentUser != null)
//                 FilledButton(
//                   child: Text("Sign Out"),
//                   onPressed: () async {
//                     await FirebaseAuth.instance.signOut();
//                     setState(() {});
//                   },
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
