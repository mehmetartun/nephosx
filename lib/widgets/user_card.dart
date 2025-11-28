import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

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
    return SizedBox(
      // width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Profile"),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                alignment: Alignment.center,
                child: CircleAvatar(
                  minRadius: minRadius,

                  foregroundImage: _parseBase64Image(user.photoBase64) != null
                      ? MemoryImage(
                          _parseBase64Image(user.photoBase64)!,
                          scale: 3,
                        )
                      : null,
                ),
              ),
              Text(
                '${user.firstName} ${user.lastName}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(user.email, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
