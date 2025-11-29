import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephosx/model/enums.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'conversions.dart';

part 'drinking_note.g.dart';

@JsonSerializable(explicitToJson: true)
class DrinkingNote {
  @TimestampConverter()
  final DateTime date;
  final String id;
  final String uid;
  final String? notes;
  @JsonKey(name: 'drink_company')
  final DrinkCompany drinkCompany;
  @JsonKey(name: 'drink_location')
  final DrinkLocation drinkLocation;

  DrinkingNote({
    this.notes,
    required this.id,
    required this.drinkCompany,
    required this.drinkLocation,
    required this.date,
    required this.uid,
  });

  factory DrinkingNote.fromJson(Map<String, dynamic> json) =>
      _$DrinkingNoteFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkingNoteToJson(this);

  DrinkingNote copyWith({
    DateTime? date,
    String? id,
    String? uid,
    String? notes,
    DrinkCompany? drinkCompany,
    DrinkLocation? drinkLocation,
  }) {
    return DrinkingNote(
      date: date ?? this.date,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      notes: notes ?? this.notes,
      drinkCompany: drinkCompany ?? this.drinkCompany,
      drinkLocation: drinkLocation ?? this.drinkLocation,
    );
  }

  static DrinkingNote? getNoteForDate(DateTime date, List<DrinkingNote> notes) {
    // return notes.firstOrNull((DrinkingNote element) {
    //   return DateTime(element.date.year, element.date.month, element.date.day) ==
    //       DateTime(date.year, date.month, date.day);
    // });
    DrinkingNote? ret;
    for (DrinkingNote nt in notes) {
      if (DateTime(nt.date.year, nt.date.month, nt.date.day) ==
          DateTime(date.year, date.month, date.day)) {
        ret = nt;
        break;
      }
    }
    return ret;
  }
}
