import 'package:flutter/material.dart';

import '../model/user.dart';
import 'user_avatar.dart';

enum UserListTileAlignment { right, left }

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
    this.trailing,
    this.alignment = UserListTileAlignment.left,
  });
  final Widget? trailing;

  final User user;

  final UserListTileAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: alignment == UserListTileAlignment.left
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          UserAvatar(user: user),
          SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.firstName?.isNotEmpty ?? false ? user.firstName! : "..."} ${user.lastName?.isNotEmpty ?? false ? user.lastName! : "..."}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                user.email ?? "...",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (user.company != null)
                Text(
                  (user.company?.name ?? "...").toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
            ],
          ),

          if (trailing != null) ...[SizedBox(width: 20), trailing!],
        ],
      ),
    );

    // return ListTile(
    //   leading: UserAvatar(user: user),
    //   title: Text(
    //     '${user.firstName?.isNotEmpty ?? false ? user.firstName! : "<First Name>"} ${user.lastName?.isNotEmpty ?? false ? user.lastName! : "<Last Name>"}',
    //   ),
    //   subtitle: Text(user.email ?? ""),
    //   trailing: trailing,
    // );
  }
}
