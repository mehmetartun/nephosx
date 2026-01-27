// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileData _$FileDataFromJson(Map<String, dynamic> json) => FileData(
  name: json['name'] as String,
  bucket: json['bucket'] as String,
  path: json['path'] as String,
  contentType: json['content_type'] as String,
  url: json['url'] as String,
  createdAt: const TimestampToEpochConverter().fromJson(
    json['created_at'] as Object,
  ),
  description: json['description'] as String?,
);

Map<String, dynamic> _$FileDataToJson(FileData instance) => <String, dynamic>{
  'name': instance.name,
  'bucket': instance.bucket,
  'path': instance.path,
  'content_type': instance.contentType,
  'url': instance.url,
  'created_at': const TimestampToEpochConverter().toJson(instance.createdAt),
  'description': instance.description,
};
