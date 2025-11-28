import 'package:flutter/material.dart';

import '../../../../widgets/views/error_view.dart';

class SignInWithGoogleWebView extends StatelessWidget {
  const SignInWithGoogleWebView({super.key, required this.signInWithIdToken});
  final void Function(String?) signInWithIdToken;

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      title: "Not Implemented",
      message: "Error - this is unimplemented in Android or IOS",
    );
  }
}
