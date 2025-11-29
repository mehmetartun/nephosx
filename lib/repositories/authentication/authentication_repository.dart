import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../database/database.dart';

enum AuthenticationExceptionCode {
  cancelled("Cancelled by User"),
  incorrectCredentials("The username or password is incorrect."),
  invalidEmail("Invalid Email"),
  unknownError("Unknown Error");

  const AuthenticationExceptionCode(this.description);
  final String description;
}

class AuthenticationException implements Exception {
  final AuthenticationExceptionCode code;
  final String? message;
  AuthenticationException({required this.code, this.message});

  @override
  String toString() => "AuthenticationException: $message";
}

abstract class AuthenticationRepository {
  User? _user;
  Future<User?> signIn({required String email, required String password});
  Future<User?> newUser({required String email, required String password});
  Future<void> signOut();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();
  Future<User?> signInWithIdToken(String idToken);
  Future<bool> get isSignedIn;

  User? get user {
    return _user;
  }
}

class FirebaseAuthenticationRepository extends AuthenticationRepository {
  static final FirebaseAuthenticationRepository instance =
      FirebaseAuthenticationRepository._internal();

  late final DatabaseRepository databaseRepository;
  auth.UserCredential? userCredential;
  void init(DatabaseRepository databaseRepository) {
    try {
      this.databaseRepository = databaseRepository;
    } catch (e) {}
  }

  FirebaseAuthenticationRepository._internal();

  Future<bool> get isSignedIn async {
    final currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _user = await databaseRepository.getUserData(currentUser.uid);
    }
    return currentUser != null;
  }

  Future<void> someFirebaseSpecificMethod() async {
    await Future.delayed(const Duration(seconds: 1), () {});
  }

  @override
  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      return null;
    }
    return await signInWithGoogleIO();
  }

  @override
  Future<User?> signInWithIdToken(String idToken) async {
    final credential = auth.GoogleAuthProvider.credential(idToken: idToken);
    userCredential = await auth.FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    // return userCredential!;
    try {
      _user = await databaseRepository.getUserData(userCredential!.user!.uid);
    } catch (e) {
      await databaseRepository.saveUserData({
        'uid': userCredential!.user!.uid,
        'email': userCredential!.user!.email,
      });
      _user = await databaseRepository.getUserData(userCredential!.user!.uid);
    }

    return _user!;
  }

  Future<User?> signInWithGoogleIO() async {
    // Trigger the authentication flow
    late GoogleSignInAccount googleUser;
    try {
      await GoogleSignIn.instance.initialize();
      googleUser = await GoogleSignIn.instance.authenticate();
    } on Exception catch (e) {
      if (e is GoogleSignInException) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          throw AuthenticationException(
            code: AuthenticationExceptionCode.cancelled,
            message: e.toString(),
          );
        }
      }
    } catch (e) {
      throw AuthenticationException(
        message: "Google Sign-in failed: $e",
        code: AuthenticationExceptionCode.unknownError,
      );
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final credential = auth.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential

    userCredential = await auth.FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    // return userCredential!;
    try {
      _user = await databaseRepository.getUserData(userCredential!.user!.uid);
    } catch (e) {
      await databaseRepository.saveUserData({
        'uid': userCredential!.user!.uid,
        'email': userCredential!.user!.email,
      });
      _user = await databaseRepository.getUserData(userCredential!.user!.uid);
    }

    return _user!;
  }

  @override
  Future<User?> signInWithApple() async {
    late auth.UserCredential userCredential;
    try {
      final appleProvider = auth.AppleAuthProvider()
        ..addScope('email')
        ..addScope('name'); // Request scopes for name and email

      if (kIsWeb) {
        userCredential = await auth.FirebaseAuth.instance.signInWithPopup(
          appleProvider,
        );
      } else {
        userCredential = await auth.FirebaseAuth.instance.signInWithProvider(
          appleProvider,
        );
      }
    } catch (e) {
      print(e.toString());
    }

    // --- 💡 THE CRITICAL STEP IS HERE ---
    // The data is NOT on userCredential.user.displayName or userCredential.user.email
    final rawUserInfo = userCredential.additionalUserInfo?.profile;

    if (rawUserInfo != null) {
      // 1. Get the name
      final firstName = rawUserInfo['given_name'] as String?;
      final lastName = rawUserInfo['family_name'] as String?;
      final fullName = (firstName != null && lastName != null)
          ? '$firstName $lastName'
          : null;

      // 2. Get the email (it can be the real one or the private relay)
      final email = rawUserInfo['email'] as String?;

      // Log the data to confirm it's present on the first sign-in
      // print('Apple Sign In: Name received: $fullName');
      // print('Apple Sign In: Email received: $email');

      // 3. **IMMEDIATELY SAVE THIS DATA** to your database (e.g., Firestore)
      // You should use the userCredential.user.uid as the document ID.
      if (fullName != null || email != null) {
        // Example of saving to Firestore/database (you need to implement this)
        // await saveUserDataToDatabase(
        //   uid: userCredential.user!.uid,
        //   name: fullName,
        //   email: email
        // );
      }
    }

    // return userCredential;
    _user = await databaseRepository.getUserData(userCredential.user!.uid);
    return _user!;
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    try {
      userCredential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on Exception catch (e) {
      if (e is auth.FirebaseAuthException) {
        print(e.code);
        switch (e.code) {
          case "invalid-email":
            throw AuthenticationException(
              code: AuthenticationExceptionCode.invalidEmail,
              message: e.toString(),
            );
          case "invalid-credential":
            throw AuthenticationException(
              code: AuthenticationExceptionCode.incorrectCredentials,
              message: e.toString(),
            );
          default:
            throw AuthenticationException(
              code: AuthenticationExceptionCode.unknownError,
              message: e.toString(),
            );
        }
      }
      throw AuthenticationException(
        code: AuthenticationExceptionCode.unknownError,
        message: e.toString(),
      );
    } catch (e) {
      throw AuthenticationException(
        code: AuthenticationExceptionCode.unknownError,
        message: e.toString(),
      );
    }

    if (userCredential?.user == null) {
      throw Exception("Sign in Failed");
    }

    return await databaseRepository.getUserData(userCredential!.user!.uid);
    // return User.fromMap({
    //   'email': userCredential!.user!.email,
    //   'uid': userCredential!.user!.uid,
    //   'displayName': userCredential!.user!.displayName,
    //   'photoUrl': userCredential!.user!.photoURL,
    // });

    // User(
    //   email: userCredential!.user!.email,
    //   uid: userCredential!.user!.uid,
    //   firstName: userCredential!.user!.displayName ?? "",
    //   lastName: userCredential!.user!.displayName ?? "",
    //   imageUrl: userCredential!.user!.photoURL ?? "",
    // );
  }

  @override
  Future<User?> newUser({
    required String email,
    required String password,
  }) async {
    try {
      userCredential = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential?.user == null) {
        throw Exception("User creation failed");
      }
      _user = await databaseRepository.getUserData(userCredential!.user!.uid);
      // await databaseRepository.saveUserData({
      //   'uid': userCredential!.user!.uid,
      //   'email': email,
      // });

      // _user = User.fromMap({
      //   'email': userCredential!.user!.email,
      //   'uid': userCredential!.user!.uid,
      //   'display_name': userCredential!.user!.displayName,
      //   'photo_url': userCredential!.user!.photoURL,
      // });

      return _user;
    } catch (e) {
      // Firebase already initialized
      throw AuthenticationException(
        message: "User creation failed: $e",
        code: AuthenticationExceptionCode.unknownError,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
    await auth.FirebaseAuth.instance.signOut();
    _user = null;
    userCredential = null;
  }
}
