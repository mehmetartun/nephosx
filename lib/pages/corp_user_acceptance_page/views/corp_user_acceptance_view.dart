import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../model/invitaton.dart';

class CorpUserAcceptanceView extends StatefulWidget {
  const CorpUserAcceptanceView({
    super.key,
    required this.invitation,
    required this.onReject,
  });
  final Invitation invitation;
  final void Function() onReject;

  @override
  State<CorpUserAcceptanceView> createState() => _CorpUserAcceptanceViewState();
}

class _CorpUserAcceptanceViewState extends State<CorpUserAcceptanceView> {
  final _formKey = GlobalKey<FormState>();
  bool invisible = true;
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "NephosX",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text("Invitation to Join ${widget.invitation.companyName}"),
            Text(""),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: MaxWidthBox(
          maxWidth: 600,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "You are invited by ${widget.invitation.companyName} to join NephosX.",
                ),
                SizedBox(height: 20),
                Text(
                  "To accept the invitation, please enter a password"
                  " below and create an account with "
                  "this email address.",
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  enabled: false,
                  initialValue: widget.invitation.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a first name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: invisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    helperText:
                        "8+ chars, 1 upper, 1 lower, 1 number, 1 special",
                    helperMaxLines: 2,
                    suffix: invisible
                        ? InkWell(
                            child: Icon(Icons.visibility),
                            onTap: () {
                              setState(() {
                                invisible = !invisible;
                              });
                            },
                          )
                        : InkWell(
                            child: Icon(Icons.visibility_off),
                            onTap: () {
                              setState(() {
                                invisible = !invisible;
                              });
                            },
                          ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    if (value.trim().length < 8) {
                      return "At least 8 characters required";
                    }
                    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                      return "At least one lowercase letter required";
                    }
                    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                      return "At least one uppercase letter required";
                    }
                    if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
                      return "At least one number required";
                    }
                    if (!RegExp(r'(?=.*[!@#\$&*~])').hasMatch(value)) {
                      return "At least one special character required";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!.trim();
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        AuthenticationEventCreateNewUserWithEmailAndPassword(
                          email: widget.invitation.email,
                          password: password,
                        ),
                      );
                      // Do something
                    }
                  },
                  child: const Text("Accept Invitation"),
                ),
                Row(
                  children: [
                    Flexible(flex: 1, child: Divider()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("or"),
                    ),
                    Flexible(flex: 1, child: Divider()),
                  ],
                ),
                ElevatedButton(
                  onPressed: widget.onReject,
                  child: const Text("Reject Invitation"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
