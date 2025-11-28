import 'package:coach/blocs/notifications/bloc/notifications_bloc.dart';
import 'package:coach/firebase_options.dart';
import 'package:coach/repositories/authentication/authentication_repository.dart';
import 'package:coach/theme/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'pages/data_entry/data_entry_page.dart';
import 'repositories/database/database.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // if (Platform.isAndroid) {
  //   FirebaseFunctions.instance.useFunctionsEmulator('10.0.2.2', 5001);
  // } else {
  //   FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DatabaseRepository databaseRepository =
        FirestoreDatabaseRepository.instance;

    AuthenticationRepository authenticationRepository =
        FirebaseAuthenticationRepository.instance..init(databaseRepository);
    AuthenticationBloc authenticationBloc = AuthenticationBloc(
      authenticationRepository,
    );

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
          ],

          child: MyMaterialApp(),
        ),
      ),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialTheme theme = MaterialTheme(
      createTextTheme(context, "Roboto", "Roboto"),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.dark(),

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // routerConfig: goRouter,
      // home: DataEntryPage(itemId: "2b2SgkiGZyTloYcmW7xF"),
      home: DataEntryPage(),

      // builder: (context, child) => ResponsiveBreakpoints.builder(
      //   breakpoints: [
      //     const Breakpoint(start: 0, end: 450, name: MOBILE),
      //     const Breakpoint(start: 451, end: 800, name: TABLET),
      //     const Breakpoint(start: 801, end: 1920, name: DESKTOP),
      //     const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      //   ],
      //   child: child!,
      // ),
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
//     final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
//         .authenticate();

//     if (googleUser == null) {
//       throw FirebaseAuthException(
//         code: 'ERROR_ABORTED_BY_USER',
//         message: 'Sign in aborted by user',
//       );
//     }
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
//     User? user = FirebaseAuth.instance.currentUser;
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
