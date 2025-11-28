import 'package:coach/blocs/authentication/authentication_bloc.dart';
import 'package:coach/widgets/views/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/views/error_view.dart';
import 'views/email_password_view.dart';
import 'views/new_user_view.dart';
import 'views/sign_in_with_google_web_view/sign_in_with_google_web_view.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc = context
        .read<AuthenticationBloc>();
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        switch (state) {
          case AuthenticationStateError _:
            return ErrorView(
              title: "Authentication Error",
              message: state.lastError.code.description,
              onRetry: () => authenticationBloc.add(
                AuthenticationEventCancelNewUserRequest(),
              ),
            );
          case AuthenticationStateNewUserRequest _:
            return NewUserView(
              newUserWithEmail:
                  ({required String email, required String password}) {
                    authenticationBloc.add(
                      AuthenticationEventCreateNewUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      ),
                    );
                  },
              cancelNewUserRequest: () {
                authenticationBloc.add(
                  AuthenticationEventCancelNewUserRequest(),
                );
              },
            );
          case AuthenticationStateSignInWithGoogleWeb _:
            return SignInWithGoogleWebView(
              signInWithIdToken: (String? idToken) {
                authenticationBloc.add(
                  AuthenticationSignInWithIdTokenEvent(idToken!),
                );
              },
            );

          case AuthenticationStateWaiting _:
            return LoadingView(
              title: "Authentication",
              message: "Authentication is in progress.",
            );
          case AuthenticationStateSignedOut _:
            return EmailPasswordView(
              lastError: state.lastError,
              signInWithEmail:
                  ({required String email, required String password}) {
                    authenticationBloc.add(
                      AuthenticationEventSignInWithEmailAndPassword(
                        email: email,
                        password: password,
                      ),
                    );
                  },
              newUserRequest: () {
                authenticationBloc.add(AuthenticationEventNewUserRequest());
              },
              signInWithApple: () {
                authenticationBloc.add(
                  AuthenticationEventSignInWithAppleRequest(),
                );
              },
              signInWithGoogle: () {
                authenticationBloc.add(
                  AuthenticationEventSignInWithGoogleRequest(),
                );
              },
            );
          case AuthenticationStateUnkown _:
          default:
            return EmailPasswordView(
              signInWithEmail:
                  ({required String email, required String password}) {
                    authenticationBloc.add(
                      AuthenticationEventSignInWithEmailAndPassword(
                        email: email,
                        password: password,
                      ),
                    );
                  },
              newUserRequest: () {
                authenticationBloc.add(AuthenticationEventNewUserRequest());
              },
              signInWithApple: () {
                authenticationBloc.add(
                  AuthenticationEventSignInWithAppleRequest(),
                );
              },
              signInWithGoogle: () {
                authenticationBloc.add(
                  AuthenticationEventSignInWithGoogleRequest(),
                );
              },
            );
        }
      },
    );
  }
}
