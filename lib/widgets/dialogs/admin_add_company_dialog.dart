import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminAddCompanyDialog extends StatefulWidget {
  const AdminAddCompanyDialog({
    Key? key,
    required this.onAddCompany,
    required this.companyName,
    required this.companyDomain,
    required this.confirmationEmail,
    required this.userId,
  }) : super(key: key);
  final void Function({
    required String companyName,
    required String companyDomain,
    required String confirmationEmail,
    required String userId,
  })
  onAddCompany;
  final String companyName;
  final String companyDomain;
  final String confirmationEmail;
  final String userId;

  @override
  State<AdminAddCompanyDialog> createState() => _AdminAddCompanyDialogState();
}

class _AdminAddCompanyDialogState extends State<AdminAddCompanyDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String companyName;
  late String confirmationEmail;
  late String companyDomain;
  late String userId;
  bool shouldAddUser = false;

  @override
  void initState() {
    companyName = widget.companyName;
    confirmationEmail = widget.confirmationEmail;
    companyDomain = widget.companyDomain;
    userId = widget.userId;
    super.initState();
  }

  String? validateNineDigits(String? value) {
    // 1. Check if input is null or empty
    if (value == null || value.isEmpty) {
      return null;
    }

    // 2. Define the Regex: Starts (^) with exactly 9 digits (\d{9}) and ends ($)
    // This ensures no letters, symbols, or spaces are allowed.
    final RegExp regex = RegExp(r'^\d{9}$');

    // 3. Test the input
    if (!regex.hasMatch(value)) {
      return 'Please enter exactly 9 digits';
    }

    // 4. Return null if validation passes
    return null;
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
                  "Add Company",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  initialValue: companyName,
                  decoration: InputDecoration(labelText: "Company Name"),
                  onSaved: (value) {
                    companyName = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a company name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  initialValue: companyDomain,
                  decoration: InputDecoration(labelText: "Company Domain"),
                  onSaved: (value) {
                    companyDomain = value!.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a company domain";
                    }
                    final domainRegex = RegExp(
                      r'^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\.)+[A-Za-z]{2,6}$',
                    );
                    if (!domainRegex.hasMatch(value.trim())) {
                      return "Please enter a valid domain address";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  initialValue: confirmationEmail,
                  decoration: InputDecoration(labelText: "Confirmation Email"),
                  onSaved: (value) {
                    confirmationEmail = value!.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a confirmation email";
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

                // if (widget.userId != null) ...[
                //   SizedBox(height: 20),
                //   CheckboxListTile(
                //     value: shouldAddUser,
                //     title: Text("Also add as corporate admin?"),
                //     onChanged: (value) {
                //       setState(() {
                //         shouldAddUser = value!;
                //       });
                //     },
                //   ),
                // ],
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();

                      widget.onAddCompany(
                        companyName: companyName,
                        companyDomain: companyDomain,
                        confirmationEmail: confirmationEmail,
                        userId: userId,
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
