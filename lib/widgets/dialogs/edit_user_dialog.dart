import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/widgets/user_list_tile.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../model/enums.dart';
import '../../model/user.dart';

class EditUserDialog extends StatefulWidget {
  EditUserDialog({Key? key, required this.updateUser, required this.user})
    : super(key: key);
  final void Function({required User user}) updateUser;
  final User user;

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late User _user;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: 500,
      child: Form(
        key: formKey,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Edit User",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: "First Name"),
                    initialValue: _user.firstName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a first name";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user = _user.copyWith(displayName: value);
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Last Name"),
                    initialValue: _user.lastName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a last name";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user = _user.copyWith(displayName: value);
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Display Name"),
                    initialValue: _user.displayName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a display name";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user = _user.copyWith(displayName: value);
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownMenuFormField<UserType>(
                    label: Text("User Type"),
                    initialSelection: _user.type,
                    dropdownMenuEntries:
                        [
                          UserType.corporateAdmin,
                          UserType.corporateBlocked,
                          UserType.corporateTrader,
                          UserType.corporateViewer,
                        ].map((type) {
                          return DropdownMenuEntry(
                            value: type,
                            label: type.title,
                          );
                        }).toList(),
                    onSaved: (value) {
                      _user = _user.copyWith(type: value!);
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: FilledButton(
                      child: Text("Update"),
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          formKey.currentState!.save();
                          widget.updateUser(user: _user);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
