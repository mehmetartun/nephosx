// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Producer _$ProducerFromJson(Map<String, dynamic> json) => Producer(
  id: json['id'] as String,
  name: json['name'] as String,
  base64Image: json['base64_image'] as String?,
);

Map<String, dynamic> _$ProducerToJson(Producer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'base64_image': instance.base64Image,
};
