import 'package:flutter/material.dart';

import '../model/invitaton.dart';

class InvitationStatusWidget extends StatelessWidget {
  const InvitationStatusWidget({Key? key, required this.invitation})
    : super(key: key);
  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    switch (invitation.status) {
      case InvitationStatus.invited:
        return Row(
          children: [
            Icon(Icons.pending_actions),
            SizedBox(width: 3),
            Text("Pending"),
          ],
        );
      case InvitationStatus.accepted:
        return Row(
          children: [Icon(Icons.check), SizedBox(width: 3), Text("Accepted")],
        );
      case InvitationStatus.rejected:
        return Row(
          children: [Icon(Icons.close), SizedBox(width: 3), Text("Rejected")],
        );
      case InvitationStatus.expired:
        return Row(
          children: [Icon(Icons.alarm), SizedBox(width: 3), Text("Expired")],
        );
    }
  }
}
