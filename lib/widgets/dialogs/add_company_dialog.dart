import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AddCompanyDialog extends StatefulWidget {
  const AddCompanyDialog({Key? key, required this.onAddCompany})
    : super(key: key);
  final void Function(Map<String, dynamic>) onAddCompany;

  @override
  State<AddCompanyDialog> createState() => _AddCompanyDialogState();
}

class _AddCompanyDialogState extends State<AddCompanyDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = "";
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
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(labelText: "Company Name"),
                  onSaved: (value) {
                    name = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a company name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      widget.onAddCompany({"name": name});
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add Company"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
