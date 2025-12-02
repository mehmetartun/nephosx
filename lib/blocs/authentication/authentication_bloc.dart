import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/company.dart';
import '../../model/user.dart';
import '../../repositories/authentication/authentication_repository.dart';
import '../../repositories/database/database.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this.authenticationRepository, this.databaseRepository)
    : super(AuthenticationStateUnkown()) {
    on<AuthenticationEventSignInWithEmailAndPassword>((event, emit) async {
      await _handleLogin(event, emit);
    });

    on<AuthenticationEventCreateNewUserWithEmailAndPassword>((
      event,
      emit,
    ) async {
      await _handleNewUser(event, emit);
    });
    on<AuthenticationEventError>((event, emit) {
      _handleError(event, emit);
    });
    on<AuthenticationEventSignOut>((event, emit) async {
      await _handleSignOut(event, emit);
    });
    on<AuthenticationEventDestinationCleared>((event, emit) {
      destination = null;
    });
    on<AuthenticationEventNewUserRequest>((event, emit) {
      _handleNewUserRequest(event, emit);
    });
    on<AuthenticationEventSignedIn>((event, emit) {
      _handleSignedIn(event, emit);
    });
    on<AuthenticationEventCancelNewUserRequest>((event, emit) {
      _handleCancelNewUserRequest(event, emit);
    });
    on<AuthenticationEventSignInWithGoogleRequest>((event, emit) async {
      if (kIsWeb) {
        await _handleSignInWithGoogleWeb(event, emit);
      } else {
        await _handleSignInWithGoogle(event, emit);
      }
    });
    on<AuthenticationEventSignInWithAppleRequest>((event, emit) async {
      await _handleSignInWithApple(event, emit);
    });

    on<AuthenticationSignInWithIdTokenEvent>((event, emit) async {
      await _handleSignInWithIdToken(event, emit);
    });
    on<AuthenticationDestinationAfterSignInEvent>((event, emit) {
      _handleSaveDestiontion(event, emit);
    });
  }
  final AuthenticationRepository authenticationRepository;
  final DatabaseRepository databaseRepository;
  User? user;

  StreamSubscription<User?>? userStreamSubscription;

  String? destination;
  void _handleSaveDestiontion(
    AuthenticationDestinationAfterSignInEvent event,
    emit,
  ) {
    destination = event.destination;
  }

  void init() async {
    final bool isSignedIn = await authenticationRepository.isSignedIn;
    if (isSignedIn) {
      user = authenticationRepository.user;
      // userStreamSubscription = databaseRepository
      //     .getUserStream(user!.uid)
      //     .listen((user) {
      //       this.user = user;
      //     });
      // await userStreamSubscription?.cancel();
      add(AuthenticationEventSignedIn());
    } else {
      if (!kIsWeb) {
        add(AuthenticationEventSignOut());
      }
    }
  }

  Future<String?> getFcmToken() async {
    if (TargetPlatform.android != defaultTargetPlatform) {
      return null;
    }
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> _handleSignInWithIdToken(event, emit) async {
    emit(AuthenticationStateWaiting());
    try {
      user = await authenticationRepository.signInWithIdToken(event.idToken);
      try {
        await FirebaseFunctions.instance.httpsCallable('updateUserToken').call({
          'uid': user?.uid,
          'fcmToken': await getFcmToken() ?? '',
          'action': 'add',
        });
      } catch (e) {
        debugPrint('Failed to update user token: $e');
      }
      emit(AuthenticationStateSignedIn(destination: destination));
      return;
    } catch (e) {
      emit(
        AuthenticationStateError(
          lastError: AuthenticationException(
            code: AuthenticationExceptionCode.unknownError,
            message: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _handleSignInWithGoogle(event, emit) async {
    emit(AuthenticationStateWaiting());
    try {
      user = await authenticationRepository.signInWithGoogle();
      try {
        await FirebaseFunctions.instance.httpsCallable('updateUserToken').call({
          'uid': user?.uid,
          'fcmToken': await getFcmToken() ?? '',
          'action': 'add',
        });
      } catch (e) {
        debugPrint('Failed to update user token: $e');
      }
      emit(AuthenticationStateSignedIn(destination: destination));
      return;
    } on Exception catch (e) {
      if (e is AuthenticationException) {
        add(AuthenticationEventError(lastError: e));
      }
    } catch (e) {
      emit(AuthenticationStateError.fromMessage(e.toString()));
    }
  }

  Future<void> _handleSignInWithGoogleWeb(event, emit) async {
    emit(AuthenticationStateSignInWithGoogleWeb());
    // try {
    //   user = await authenticationRepository.signInWithGoogle();
    //   emit(AuthenticationStateSignedIn());
    //   return;
    // } catch (e) {
    //   emit(AuthenticationStateError(errorText: e.toString()));

    // }
  }

  Future<void> _handleSignInWithApple(event, emit) async {
    emit(AuthenticationStateWaiting());
    try {
      user = await authenticationRepository.signInWithApple();
      try {
        await FirebaseFunctions.instance.httpsCallable('updateUserToken').call({
          'uid': user?.uid,
          'fcmToken': await getFcmToken() ?? '',
          'action': 'add',
        });
      } catch (e) {
        debugPrint('Failed to update user token: $e');
      }
      emit(AuthenticationStateSignedIn(destination: destination));
      return;
    } catch (e) {
      emit(AuthenticationStateError.fromMessage(e.toString()));
    }
  }

  void _handleSignedIn(event, emit) {
    emit(AuthenticationStateSignedIn(destination: destination));
  }

  Future<void> _handleSignOut(event, emit) async {
    emit(AuthenticationStateWaiting());

    user = null;
    await authenticationRepository.signOut();
    emit(AuthenticationStateSignedOut());
  }

  void _handleError(AuthenticationEventError event, emit) {
    switch (event.lastError.code) {
      case AuthenticationExceptionCode.cancelled:
        emit(AuthenticationStateSignedOut());
        break;
      case AuthenticationExceptionCode.incorrectCredentials:
      case AuthenticationExceptionCode.invalidEmail:
        emit(AuthenticationStateSignedOut(lastError: event.lastError));
        break;
      default:
        emit(AuthenticationStateError(lastError: event.lastError));
        break;
    }
  }

  Future<void> _handleLogin(event, emit) async {
    emit(AuthenticationStateWaiting());
    try {
      user = await authenticationRepository.signIn(
        email: event.email,
        password: event.password,
      );
      try {
        await FirebaseFunctions.instance.httpsCallable('updateUserToken').call({
          'uid': user?.uid,
          'fcmToken': await getFcmToken() ?? '',
          'action': 'add',
        });
      } catch (e) {
        debugPrint('Failed to update user token: $e');
      }

      emit(AuthenticationStateSignedIn(destination: destination));
      return;
    } on Exception catch (e) {
      if (e is AuthenticationException) {
        switch (e.code) {
          case AuthenticationExceptionCode.invalidEmail:
          case AuthenticationExceptionCode.incorrectCredentials:
            emit(AuthenticationStateSignedOut(lastError: e));
            return;
          default:
            emit(AuthenticationStateSignedOut(lastError: e));
            return;
        }
      }
      rethrow;
    } catch (e) {
      // emit(AuthenticationStateError.fromMessage(e.toString()));
      emit(AuthenticationStateError.fromMessage(e.toString()));
    }
  }

  Future<void> _handleNewUser(event, emit) async {
    emit(AuthenticationStateWaiting());
    try {
      user = await authenticationRepository.newUser(
        email: event.email,
        password: event.password,
      );
      try {
        await FirebaseFunctions.instance.httpsCallable('updateUserToken').call({
          'uid': user?.uid,
          'fcmToken': await getFcmToken() ?? '',
          'action': 'add',
        });
      } catch (e) {
        debugPrint('Failed to update user token: $e');
      }

      emit(AuthenticationStateSignedIn(destination: destination));
      return;
    } catch (e) {
      emit(AuthenticationStateError.fromMessage(e.toString()));
    }
  }

  void _handleNewUserRequest(event, emit) {
    emit(AuthenticationStateNewUserRequest());
  }

  void _handleCancelNewUserRequest(event, emit) {
    emit(AuthenticationStateSignedOut());
  }
}
