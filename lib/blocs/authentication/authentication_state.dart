part of 'authentication_bloc.dart';

sealed class AuthenticationState {}

final class AuthenticationStateUnkown extends AuthenticationState {}

final class AuthenticationStateError extends AuthenticationState {
  final AuthenticationException lastError;

  AuthenticationStateError({required this.lastError});

  AuthenticationStateError.fromMessage(String message)
    : lastError = AuthenticationException(
        code: AuthenticationExceptionCode.unknownError,
        message: message,
      );
}

final class AuthenticationStateWaiting extends AuthenticationState {}

final class AuthenticationStateNewUserRequest extends AuthenticationState {}

final class AuthenticationStateSignedIn extends AuthenticationState {
  String? destination;
  User user;

  AuthenticationStateSignedIn({this.destination, required this.user});
}

final class AuthenticationStateSignedOut extends AuthenticationState {
  AuthenticationException? lastError;
  AuthenticationStateSignedOut({this.lastError});
}

final class AuthenticationStateSignInWithGoogleWeb
    extends AuthenticationState {}
