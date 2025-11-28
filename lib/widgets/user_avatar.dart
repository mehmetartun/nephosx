import 'package:flutter/material.dart';

import '../model/user.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, this.onTap});
  final User user;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return onTap == null
        ? CircleAvatar(child: Text('${user.firstName[0]}${user.lastName[0]}'))
        : GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              child: Text('${user.firstName[0]}${user.lastName[0]}'),
            ),
          );
  }
}
