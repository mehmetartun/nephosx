import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/company.dart';

class EditCompanyDialog extends StatefulWidget {
  const EditCompanyDialog({
    Key? key,
    required this.onUpdateCompany,
    required this.company,
  }) : super(key: key);
  final void Function(Company) onUpdateCompany;
  final Company company;

  @override
  State<EditCompanyDialog> createState() => _EditCompanyDialogState();
}

class _EditCompanyDialogState extends State<EditCompanyDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String name;
  late String city;
  late String country;
  @override
  void initState() {
    super.initState();
    name = widget.company.name;
    // city = widget.company.city;
    // country = widget.company.country;
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
                Text("Update Company"),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(labelText: "Name"),
                  initialValue: name,
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

                // SizedBox(height: 20),
                // TextFormField(
                //   autocorrect: false,
                //   decoration: InputDecoration(labelText: "City"),
                //   initialValue: city,
                //   onSaved: (value) {
                //     city = value!;
                //   },
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter a company city";
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(height: 20),
                // TextFormField(
                //   autocorrect: false,
                //   decoration: InputDecoration(labelText: "Country"),
                //   initialValue: country,
                //   onSaved: (value) {
                //     country = value!;
                //   },
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter a company country";
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        widget.onUpdateCompany(
                          widget.company.copyWith(
                            name: name,
                            // city: city,
                            // country: country,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
