import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class Conversions {
  static double mlToOz(double ml) {
    return ml / 29.5735;
  }

  static double ozToMl(double oz) {
    return oz * 29.5735;
  }

  static String getInitials(String? displayName) {
    if (displayName == null || displayName.trim().isEmpty) {
      return '';
    }

    // Split by whitespace and filter out empty parts
    final nameParts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (nameParts.isEmpty) {
      return '';
    } else if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    } else {
      // Use the first letter of the first and last name parts
      return (nameParts.first[0] + nameParts.last[0]).toUpperCase();
    }
  }
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  /// Converts a Firestore [Timestamp] into a [DateTime] object.
  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  /// Converts a [DateTime] object into a Firestore [Timestamp].
  @override
  Timestamp toJson(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}
