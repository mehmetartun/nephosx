import 'package:flutter/material.dart';
import 'package:nephosx/widgets/dialogs/update_user_company_dialog.dart';
import 'package:nephosx/widgets/user_avatar.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/company.dart';
import '../../../model/enums.dart';
import '../../../model/user.dart';
import '../../../widgets/user_list_tile.dart';

class UsersView extends StatefulWidget {
  const UsersView({
    Key? key,
    required this.users,
    required this.companies,
    required this.onUpdateUser,
  }) : super(key: key);
  final List<User> users;
  final List<Company> companies;
  final void Function(Company, User) onUpdateUser;

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  late bool _hideAnonymous;
  late List<User> _users;

  @override
  void initState() {
    // TODO: implement initState
    _hideAnonymous = false;
    _users = widget.users;
    super.initState();
  }

  void onHide() {
    setState(() {
      _hideAnonymous = !_hideAnonymous;
      if (_hideAnonymous) {
        _users = widget.users
            .where((user) => user.type != UserType.anonymous)
            .toList();
      } else {
        _users = widget.users;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MaxWidthBox(
            alignment: Alignment.topCenter,
            maxWidth: 700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Users",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Row(
                  children: [
                    Text("Hide Anonymous"),
                    Switch(
                      value: _hideAnonymous,
                      onChanged: (value) {
                        onHide();
                      },
                    ),
                  ],
                ),
                // Expanded(
                //   child: ListView(
                //     children: users
                //         .map(
                //           (user) => UserListTile(
                //             user: user,
                //             trailing: user.type == UserType.admin
                //                 ? null
                //                 : user.getCompany(companies) == null
                //                 ? FilledButton(
                //                     child: Text("Add"),
                //                     onPressed: () async {
                //                       await showDialog(
                //                         context: context,
                //                         builder: (context) {
                //                           return UpdateUserCompanyDialog(
                //                             onUpdateUser: onUpdateUser,
                //                             user: user,
                //                             companies: companies,
                //                           );
                //                         },
                //                       );
                //                     },
                //                   )
                //                 : Text(
                //                     user
                //                             .getCompany(companies)
                //                             ?.name
                //                             .toUpperCase() ??
                //                         "COMPANY",
                //                     style: Theme.of(
                //                       context,
                //                     ).textTheme.labelMedium,
                //                   ),
                //           ),
                //         )
                //         .toList(),
                //   ),
                // ),
                Theme(
                  data: Theme.of(context).copyWith(
                    dataTableTheme: DataTableThemeData(
                      columnSpacing: 8,
                      horizontalMargin: 8,
                      dataTextStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("Image")),
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Email")),
                      DataColumn(label: Text("Type")),
                      DataColumn(label: Text("Company")),
                    ],
                    rows: _users
                        .map(
                          (user) => DataRow(
                            cells: [
                              DataCell(UserAvatar(user: user, radius: 14)),
                              DataCell(Text(user.displayName ?? "")),
                              DataCell(Text(user.email ?? "")),
                              DataCell(Text(user.type?.title ?? "")),
                              DataCell(Text(user.company?.name ?? "")),
                            ],
                          ),
                        )
                        .toList(),
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
