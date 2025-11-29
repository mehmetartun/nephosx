import 'package:flutter/material.dart';
import 'package:nephosx/widgets/user_list_tile.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/company.dart';
import '../../model/user.dart';

class UpdateUserCompanyDialog extends StatefulWidget {
  const UpdateUserCompanyDialog({
    super.key,
    required this.onUpdateUser,
    required this.user,
    required this.companies,
  });
  final void Function(Company, User) onUpdateUser;
  final User user;
  final List<Company> companies;

  @override
  State<UpdateUserCompanyDialog> createState() =>
      _UpdateUserCompanyDialogState();
}

class _UpdateUserCompanyDialogState extends State<UpdateUserCompanyDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Company? company;
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
                UserListTile(user: widget.user),
                DropdownButtonFormField<Company>(
                  decoration: InputDecoration(labelText: "Company"),
                  validator: (value) {
                    if (value == null) {
                      return "Please select a company";
                    }
                    return null;
                  },
                  items: widget.companies.map((company) {
                    return DropdownMenuItem(
                      value: company,
                      child: Text(company.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      company = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      widget.onUpdateUser(company!, widget.user);
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Update Company"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
