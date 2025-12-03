import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../model/enums.dart';
import '../../../repositories/authentication/authentication_repository.dart';
import '../../../widgets/error_banner.dart';

class EmailPasswordView extends StatefulWidget {
  const EmailPasswordView({
    super.key,
    required this.signInWithEmail,
    required this.newUserRequest,
    required this.signInWithGoogle,
    required this.signInWithApple,
    this.lastError,
  });
  final void Function({required String email, required String password})
  signInWithEmail;
  final void Function() newUserRequest;
  final void Function() signInWithGoogle;
  final void Function() signInWithApple;
  final AuthenticationException? lastError;

  @override
  State<EmailPasswordView> createState() => _EmailPasswordViewState();
}

class _EmailPasswordViewState extends State<EmailPasswordView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? email;
  String? password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Login Page"),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         BlocProvider.of<AuthenticationBloc>(
      //           context,
      //         ).add(AuthenticationEventSignOut());
      //       },
      //       icon: Icon(Icons.logout),
      //     ),
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // title: Text("Sign In"),
            pinned: true,
            snap: true,
            floating: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/nephosx2/nephosx.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: MaxWidthBox(
              maxWidth: 500,
              child: Center(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        RichText(
                          text: TextSpan(
                            text: "If you have an account, please sign in or ",
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: "  Sign up  ",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = widget.newUserRequest,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(label: Text("Email")),
                          onSaved: (val) {
                            email = val;
                          },
                          validator: (val) {
                            if (val == null || val.trim() == "") {
                              return "Email must not be empty";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(label: Text("Password")),
                          onSaved: (val) {
                            password = val;
                          },
                          validator: (val) {
                            if (val == null || val.trim() == "") {
                              return "Password must not be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        if (widget.lastError != null) ...[
                          ErrorBanner(
                            errorType: ErrorType.loginError,
                            width: double.infinity,
                            text:
                                widget.lastError!.message ??
                                widget.lastError!.code.description,
                          ),

                          SizedBox(height: 20),
                        ],

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            FilledButton(
                              child: Text("Login"),
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  formKey.currentState?.save();
                                  widget.signInWithEmail(
                                    email: email!,
                                    password: password!,
                                  );
                                }
                              },
                            ),
                            TextButton(
                              child: Text("Forgot Password?"),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        Text(
                          "Click any of the buttons below to login as a test user",
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilledButton.tonal(
                              onPressed: () {
                                widget.signInWithEmail(
                                  email: "mehmet+2@artun.com",
                                  password: "Password",
                                );
                              },
                              child: Text("Public"),
                            ),
                            FilledButton.tonal(
                              onPressed: () {
                                widget.signInWithEmail(
                                  email: "mehmet+5@artun.com",
                                  password: "Password",
                                );
                              },
                              child: Text("BaseflightCo"),
                            ),
                            FilledButton.tonal(
                              onPressed: () {
                                widget.signInWithEmail(
                                  email: "mehmet+4@artun.com",
                                  password: "Password",
                                );
                              },
                              child: Text("BytewiseCo"),
                            ),
                            FilledButton.tonal(
                              onPressed: () {
                                widget.signInWithEmail(
                                  email: "mehmet+6@artun.com",
                                  password: "Password",
                                );
                              },
                              child: Text("NephosX Admin"),
                            ),
                          ],
                        ),

                        // FilledButton.icon(
                        //   icon: GoogleIcon(),
                        //   label: Text("Sign in with Google"),
                        //   onPressed: () {},
                        // ),
                        // FilledButton.icon(
                        //   icon: AppleIcon(),
                        //   label: Text("Sign in with Apple"),
                        //   onPressed: () {},
                        // ),
                        // Divider(height: 40),
                        // Container(
                        //   width: double.infinity,
                        //   child: SignInButton(
                        //     // Theme.of(context).brightness == Brightness.dark
                        //     //     ? Buttons.GoogleDark
                        //     //     :
                        //     Buttons.Google,

                        //     onPressed: widget.signInWithGoogle,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(100),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 20),
                        // if (!kIsWeb ||
                        //     defaultTargetPlatform == TargetPlatform.iOS)
                        //   Container(
                        //     width: double.infinity,
                        //     child: SignInButton(
                        //       elevation: 0,
                        //       // Theme.of(context).brightness == Brightness.dark
                        //       //     ? Buttons.AppleDark
                        //       //     :
                        //       Buttons.Apple,
                        //       onPressed: widget.signInWithApple,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(100),
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
