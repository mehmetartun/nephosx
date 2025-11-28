import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class Conversions {
  static double mlToOz(double ml) {
    return ml / 29.5735;
  }

  static double ozToMl(double oz) {
    return oz * 29.5735;
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
