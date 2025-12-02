part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {}

class AuthenticationEventSignInWithEmailAndPassword
    extends AuthenticationEvent {
  final String email;
  final String password;
  AuthenticationEventSignInWithEmailAndPassword({
    required this.email,
    required this.password,
  });
}

class AuthenticationEventDestinationCleared extends AuthenticationEvent {}

class AuthenticationDestinationAfterSignInEvent extends AuthenticationEvent {
  final String destination;
  AuthenticationDestinationAfterSignInEvent({required this.destination});
}

class AuthenticationEventCreateNewUserWithEmailAndPassword
    extends AuthenticationEvent {
  final String email;
  final String password;
  AuthenticationEventCreateNewUserWithEmailAndPassword({
    required this.email,
    required this.password,
  });
}

class AuthenticationSignInWithIdTokenEvent extends AuthenticationEvent {
  final String idToken;
  AuthenticationSignInWithIdTokenEvent(this.idToken);
}

class AuthenticationEventError extends AuthenticationEvent {
  AuthenticationException lastError;
  AuthenticationEventError({required this.lastError});
}

class AuthenticationEventSignInWithGoogleRequest extends AuthenticationEvent {}

class AuthenticationEventSignInWithAppleRequest extends AuthenticationEvent {}

class AuthenticationEventSignedIn extends AuthenticationEvent {}

class AuthenticationEventSignOut extends AuthenticationEvent {}

class AuthenticationEventCheckAuthentication extends AuthenticationEvent {}

class AuthenticationEventNewUserRequest extends AuthenticationEvent {}

class AuthenticationEventCancelNewUserRequest extends AuthenticationEvent {}
