import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/widgets/dialogs/add_invitation_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../constants.dart';
import '../../../model/invitaton.dart';
import '../../../model/user.dart';
import '../../../widgets/dialogs/edit_user_dialog.dart';
import '../../../widgets/invitation_status_widget.dart';
import '../../../widgets/user_avatar.dart';

class CorpAdminUsersView extends StatefulWidget {
  const CorpAdminUsersView({
    Key? key,
    required this.users,
    required this.invitations,
    required this.addInvitation,
    required this.updateUser,
    required this.onSetPrimaryContact,
    this.primaryContactId,
  }) : super(key: key);
  final List<User> users;
  final List<Invitation> invitations;
  final void Function({required String email, required String displayName})
  addInvitation;
  final void Function({required User user}) updateUser;
  final void Function({required String uid}) onSetPrimaryContact;
  final String? primaryContactId;

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
          padding: kColumnPadding,
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
                SizedBox(height: 10),
                SizedBox(height: 10),

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
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    width: double.infinity,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("Image")),
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Email")),
                        DataColumn(label: Text("Type")),
                        DataColumn(label: Text("Company")),
                        DataColumn(label: Text("Actions")),
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
                                DataCell(
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed:
                                            user.uid ==
                                                BlocProvider.of<
                                                      AuthenticationBloc
                                                    >(context)
                                                    .user
                                                    ?.uid
                                            ? null
                                            : () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return EditUserDialog(
                                                      user: user,
                                                      updateUser:
                                                          widget.updateUser,
                                                    );
                                                  },
                                                );
                                              },
                                        child: Text("Edit"),
                                      ),
                                      SizedBox(width: 10),
                                      TextButton(
                                        onPressed:
                                            user.uid != widget.primaryContactId
                                            ? () {
                                                widget.onSetPrimaryContact(
                                                  uid: user.uid,
                                                );
                                              }
                                            : null,
                                        child:
                                            user.uid != widget.primaryContactId
                                            ? Text("Make Primary")
                                            : Text("Primary"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Invitations",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    OutlinedButton.icon(
                      icon: Icon(Icons.person_add),
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
                      label: Text("New Invitation"),
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
                  child: Container(
                    width: double.infinity,
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
                                DataCell(
                                  InvitationStatusWidget(
                                    invitation: invitation,
                                  ),
                                ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
