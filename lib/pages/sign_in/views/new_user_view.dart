import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NewUserView extends StatefulWidget {
  const NewUserView({
    super.key,
    required this.newUserWithEmail,
    required this.cancelNewUserRequest,
  });
  final void Function({required String email, required String password})
  newUserWithEmail;

  final void Function() cancelNewUserRequest;

  @override
  State<NewUserView> createState() => _NewUserViewState();
}

class _NewUserViewState extends State<NewUserView> {
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
      // appBar: AppBar(title: Text("New User Page")),
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
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Sign up with your email or ",
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: "  Sign In ",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.cancelNewUserRequest,
                            ),
                          ],
                        ),
                      ),

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
                      FilledButton(
                        child: Text("Sign Up"),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            formKey.currentState?.save();
                            widget.newUserWithEmail(
                              email: email!,
                              password: password!,
                            );
                          }
                        },
                      ),
                      // Divider(height: 20),
                      // SignInButton(
                      //   Buttons.Google,
                      //   text: "Sign up with Google",
                      //   onPressed: () {},
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(100),
                      //   ),
                      // ),
                      // if (!kIsWeb ||
                      //     defaultTargetPlatform != TargetPlatform.iOS)
                      //   SignInButton(
                      //     Buttons.Apple,
                      //     text: "Sign up with Apple",
                      //     onPressed: () {},
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(100),
                      //     ),
                      //   ),
                    ],
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
