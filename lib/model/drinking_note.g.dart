// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drinking_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkingNote _$DrinkingNoteFromJson(Map<String, dynamic> json) => DrinkingNote(
  notes: json['notes'] as String?,
  id: json['id'] as String,
  drinkCompany: $enumDecode(_$DrinkCompanyEnumMap, json['drink_company']),
  drinkLocation: $enumDecode(_$DrinkLocationEnumMap, json['drink_location']),
  date: const TimestampConverter().fromJson(json['date'] as Timestamp),
  uid: json['uid'] as String,
);

Map<String, dynamic> _$DrinkingNoteToJson(DrinkingNote instance) =>
    <String, dynamic>{
      'date': const TimestampConverter().toJson(instance.date),
      'id': instance.id,
      'uid': instance.uid,
      'notes': instance.notes,
      'drink_company': _$DrinkCompanyEnumMap[instance.drinkCompany]!,
      'drink_location': _$DrinkLocationEnumMap[instance.drinkLocation]!,
    };

const _$DrinkCompanyEnumMap = {
  DrinkCompany.alone: 'alone',
  DrinkCompany.friends: 'friends',
  DrinkCompany.family: 'family',
  DrinkCompany.colleagues: 'colleagues',
  DrinkCompany.event: 'event',
};

const _$DrinkLocationEnumMap = {
  DrinkLocation.home: 'home',
  DrinkLocation.bar: 'bar',
  DrinkLocation.work: 'work',
  DrinkLocation.club: 'club',
  DrinkLocation.restaurant: 'restaurant',
  DrinkLocation.event: 'event',
  DrinkLocation.houseParty: 'house_party',
  DrinkLocation.travel: 'travel',
};
