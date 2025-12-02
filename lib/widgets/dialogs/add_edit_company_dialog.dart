import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/address.dart';
import '../../model/company.dart';

class AddEditCompanyDialog extends StatefulWidget {
  const AddEditCompanyDialog({
    Key? key,
    this.onAddCompany,
    this.onUpdateCompany,
    this.company,
  }) : super(key: key);
  final void Function(Map<String, dynamic>)? onAddCompany;
  final void Function(Company)? onUpdateCompany;
  final Company? company;

  @override
  State<AddEditCompanyDialog> createState() => _AddEditCompanyDialogState();
}

class _AddEditCompanyDialogState extends State<AddEditCompanyDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Company? _company;

  String? name;
  String? confirmationEmail;
  List<Address> addresses = [];
  String? businessTaxId;
  String? businessDunsNumber;
  String? primaryContactId;
  bool? isBuyer;
  bool? isSeller;

  @override
  void initState() {
    _company = widget.company;
    name = _company?.name;
    confirmationEmail = _company?.confirmationEmail;
    addresses = _company?.addresses ?? [];
    businessTaxId = _company?.businessTaxId;
    businessDunsNumber = _company?.businessDunsNumber;
    isBuyer = _company?.isBuyer;
    isSeller = _company?.isSeller;
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
                  widget.company == null ? "Add Company" : "Update Company",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  initialValue: name,
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
                TextFormField(
                  autocorrect: false,
                  initialValue: confirmationEmail,
                  decoration: InputDecoration(labelText: "Confirmation Email"),
                  onSaved: (value) {
                    confirmationEmail = value!;
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
                  initialValue: businessTaxId,
                  decoration: InputDecoration(labelText: "Business Tax ID"),
                  onSaved: (value) {
                    businessTaxId = value!;
                  },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return "Please enter a city";
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  initialValue: businessDunsNumber,
                  decoration: InputDecoration(
                    labelText: "Business DUNS Number",
                  ),
                  onSaved: (value) {
                    businessDunsNumber = value!;
                  },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return "Please enter a country";
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      tristate: false,
                      value: isBuyer ?? false,
                      onChanged: (value) {
                        setState(() {
                          isBuyer = value;
                        });
                      },
                    ),
                    Text("Buyer"),
                    Spacer(),
                    Checkbox(
                      tristate: false,
                      value: isSeller ?? false,
                      onChanged: (value) {
                        setState(() {
                          isSeller = value;
                        });
                      },
                    ),
                    Text("Seller"),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      if (widget.company == null) {
                        if (widget.onAddCompany != null) {
                          widget.onAddCompany!({
                            'name': name,
                            'business_tax_id': businessTaxId,
                            'business_duns_number': businessDunsNumber,
                            'confirmation_email': confirmationEmail,
                            'is_buyer': isBuyer,
                            'is_seller': isSeller,
                          });
                        }
                      } else {
                        if (widget.onUpdateCompany != null) {
                          widget.onUpdateCompany!(
                            widget.company!.copyWith(
                              name: name,
                              businessTaxId: businessTaxId,
                              businessDunsNumber: businessDunsNumber,
                              confirmationEmail: confirmationEmail,
                              isBuyer: isBuyer,
                              isSeller: isSeller,
                            ),
                          );
                        }
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.company == null ? "Add" : "Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
