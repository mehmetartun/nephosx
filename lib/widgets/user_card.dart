import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/blocs/authentication/authentication_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../model/user.dart';
import '../services/logger_service.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, this.minRadius = 40});
  final User user;
  final double minRadius;

  Uint8List? _parseBase64Image(String? photoBase64) {
    Uint8List? imageBytes;
    if (photoBase64 == null || photoBase64.isEmpty) {
      return null;
    }

    try {
      // Handle data URL format (e.g., "data:image/jpeg;base64,/9j/4AAQ...")
      if (photoBase64.startsWith('data:')) {
        // Extract the base64 part after the comma
        final commaIndex = photoBase64.indexOf(',');
        if (commaIndex != -1) {
          final base64Data = photoBase64.substring(commaIndex + 1);
          imageBytes = base64Decode(base64Data);
          return imageBytes;
        }
      } else {
        // Handle plain base64 string
        imageBytes = base64Decode(photoBase64);
        return imageBytes;
      }
    } catch (e) {
      Logs.instance.error('Error parsing base64 image: $e');
      return null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: double.infinity),
        Container(
          decoration: ShapeDecoration(shape: CircleBorder()),
          clipBehavior: Clip.hardEdge,
          child: user.photoBase64 == null
              ? Container(
                  height: 140,
                  width: 140,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : Image.memory(
                  _parseBase64Image(user.photoBase64)!,
                  height: 140,
                  fit: BoxFit.cover,
                ),
        ),
        SizedBox(height: 10),
        Text(
          user.displayName ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(user.email ?? ""),
            SizedBox(width: 10),
            if (user.emailVerified == false) ...[
              Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
              SizedBox(width: 10),
              FilledButton(
                child: Text("Verify"),
                onPressed: () async {
                  var authenticationBloc = BlocProvider.of<AuthenticationBloc>(
                    context,
                  );
                  var res = await showDialog<bool>(
                    context: context,
                    builder: (context) => MaxWidthBox(
                      maxWidth: 500,
                      child: AlertDialog(
                        title: Text("Verify Email"),
                        content: Text(
                          "Please verify your email to continue. "
                          "During email verification process, you will be logged out. "
                          "Please click on the link sent to your email and log back in again.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("Cancel"),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text("Verify"),
                          ),
                        ],
                      ),
                    ),
                  );
                  if (res == true) {
                    authenticationBloc.add(
                      AuthenticationEventSendEmailVerification(),
                    );
                  }
                },
              ),
            ],
            if (user.emailVerified == true)
              Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ],
    );
  }
}
