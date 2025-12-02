import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/user.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.user,
    this.onTap,
    this.radius = 20,
  });
  final User user;
  final double radius;
  final void Function()? onTap;

  Widget _getAvatar(User user, BuildContext context) {
    bool hasImage = user.photoBase64 != null && user.photoBase64!.isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary, // Background for initials
      // 2. Logic: If image exists, use MemoryImage. If not, backgroundImage is null.
      backgroundImage: hasImage
          ? MemoryImage(base64Decode(user.photoBase64!))
          : null,
      // 3. Logic: If no image, show Text child. If image exists, child is null.
      child: hasImage
          ? null
          : Text(
              user.initials,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.8, // Dynamic font size based on radius
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (onTap == null) {
      return _getAvatar(user, context);
    } else {
      return GestureDetector(onTap: onTap, child: _getAvatar(user, context));
    }
  }
}
