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

class PasswordResetView extends StatefulWidget {
  const PasswordResetView({
    super.key,

    required this.onCancel,
    required this.onPasswordReset,
  });

  final void Function() onCancel;
  final void Function(String email) onPasswordReset;

  @override
  State<PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  String? email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
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
            title: Text(
              "NephosX",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 60,
              ),
            ),
            centerTitle: true,
            toolbarHeight: 100,
            pinned: true,
            snap: true,
            floating: true,
            // backgroundColor: Colors.transparent,
            // expandedHeight: 200,
            // flexibleSpace: FlexibleSpaceBar(
            //   background: Image.asset(
            //     "assets/images/nephosx2/nephosx.png",
            //     fit: BoxFit.fitHeight,
            //   ),
            //   title: Text("Sign In"),
            // ),
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
                        Text(
                          "Password Reset",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Please enter your email below to receive a link to reset your password.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(label: Text("Email")),
                          onSaved: (val) {
                            email = val;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a valid email";
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.+]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          child: FilledButton(
                            child: Text("Send Reset Link"),
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                formKey.currentState?.save();
                                widget.onPasswordReset(email!);
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 20),
                        TextButton.icon(
                          icon: Icon(Icons.arrow_back),
                          label: Text("Back to Sign In"),
                          onPressed: () {
                            widget.onCancel();
                          },
                        ),
                        SizedBox(height: 20),
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
