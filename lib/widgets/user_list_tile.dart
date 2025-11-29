import 'package:flutter/material.dart';

import '../model/user.dart';
import 'user_avatar.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({super.key, required this.user, this.trailing});
  final Widget? trailing;
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(user: user),
      title: Text(
        '${user.firstName.isNotEmpty ? user.firstName : "<First Name>"} ${user.lastName.isNotEmpty ? user.lastName : "<Last Name>"}',
      ),
      subtitle: Text(user.email),
      trailing: trailing,
    );
  }
}
