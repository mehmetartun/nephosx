import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as gsiweb;
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart'
    as gsi;

class SignInWithGoogleWebView extends StatefulWidget {
  const SignInWithGoogleWebView({super.key, required this.signInWithIdToken});
  final void Function(String?) signInWithIdToken;

  @override
  State<SignInWithGoogleWebView> createState() =>
      _SignInWithGoogleWebViewState();
}

class _SignInWithGoogleWebViewState extends State<SignInWithGoogleWebView> {
  final gsi.GoogleSignInPlatform _platform = gsi.GoogleSignInPlatform.instance;

  late Future future;
  @override
  void initState() {
    super.initState();

    future = _platform.init(gsi.InitParameters());
    _platform.authenticationEvents?.listen((gsi.AuthenticationEvent authEvent) {
      setState(() {
        switch (authEvent) {
          case gsi.AuthenticationEventSignIn():
            widget.signInWithIdToken(authEvent.authenticationTokens.idToken!);
          // widget.authenticationBloc.add(
          //   AuthenticationSignInWithIdTokenEvent(
          //     authEvent.authenticationTokens.idToken!,
          //   ),
          // );

          case gsi.AuthenticationEventSignOut():
          case gsi.AuthenticationEventException():
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In with Google")),
      body: Center(
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return gsiweb.renderButton(
                configuration: gsiweb.GSIButtonConfiguration(
                  type: gsiweb.GSIButtonType.standard,
                  text: gsiweb.GSIButtonText.signinWith,
                  theme: gsiweb.GSIButtonTheme.outline,
                  shape: gsiweb.GSIButtonShape.pill,
                  size: gsiweb.GSIButtonSize.medium,
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
