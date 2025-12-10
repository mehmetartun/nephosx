import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/widgets/dialogs/add_invitation_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/invitaton.dart';
import '../../../model/user.dart';
import '../../../widgets/user_avatar.dart';

class CorpAdminUsersView extends StatefulWidget {
  const CorpAdminUsersView({
    Key? key,
    required this.users,
    required this.invitations,
    required this.addInvitation,
  }) : super(key: key);
  final List<User> users;
  final List<Invitation> invitations;
  final void Function({required String email, required String displayName})
  addInvitation;

  @override
  State<CorpAdminUsersView> createState() => _CorpAdminUsersViewState();
}

class _CorpAdminUsersViewState extends State<CorpAdminUsersView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MaxWidthBox(
            alignment: Alignment.topLeft,
            maxWidth: 700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Corporate Users",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                // Row(
                //   children: [
                //     Text("Hide Anonymous"),
                //     Switch(
                //       value: _hideAnonymous,
                //       onChanged: (value) {
                //         onHide();
                //       },
                //     ),
                //   ],
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
                    rows: widget.users
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Invitations"),
                    TextButton(
                      onPressed: () async {
                        var res = await showDialog(
                          context: context,
                          builder: (context) {
                            return AddInvitationDialog(
                              onAddInvitation: widget.addInvitation,
                            );
                          },
                        );
                      },
                      child: Text("New Invitation"),
                    ),
                  ],
                ),
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
                      DataColumn(label: Text("Display Name")),
                      DataColumn(label: Text("Email")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Created At")),
                    ],
                    rows: widget.invitations
                        .map(
                          (invitation) => DataRow(
                            cells: [
                              DataCell(Text(invitation.displayName)),
                              DataCell(Text(invitation.email)),
                              DataCell(Text(invitation.status.name)),
                              DataCell(
                                Text(
                                  DateFormat(
                                    "yyyy-MM-dd",
                                  ).format(invitation.createdAt),
                                ),
                              ),
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
