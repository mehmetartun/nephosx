import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AddInvitationDialog extends StatefulWidget {
  const AddInvitationDialog({Key? key, required this.onAddInvitation})
    : super(key: key);

  final void Function({required String email, required String displayName})
  onAddInvitation;

  @override
  State<AddInvitationDialog> createState() => _AddInvitationDialogState();
}

class _AddInvitationDialogState extends State<AddInvitationDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email;
  String? displayName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: MaxWidthBox(
        maxWidth: 500,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Send Invitation",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  initialValue: email,
                  decoration: InputDecoration(labelText: "Display Name"),
                  onSaved: (value) {
                    displayName = value!.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  initialValue: email,
                  decoration: InputDecoration(labelText: "Email"),
                  onSaved: (value) {
                    email = value!.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an email";
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.+]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),

                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      widget.onAddInvitation(
                        email: email!,
                        displayName: displayName!,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Send Invitation"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
