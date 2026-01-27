import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/model/conversions.dart';

part 'file_data.g.dart';

@JsonSerializable(explicitToJson: true)
class FileData {
  // const fileData = {
  //     path: filePath,
  //     bucket: fileBucket,
  //     name: fileName,
  //     content_type: contentType,
  //     url: event.data.mediaLink || `https://storage.googleapis.com/${fileBucket}/${filePath}`,
  //     created_at: Timestamp.now(),
  // };
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'bucket')
  final String bucket;
  @JsonKey(name: 'path')
  final String path;
  @JsonKey(name: 'content_type')
  final String contentType;
  @JsonKey(name: 'url')
  final String url;
  @TimestampToEpochConverter()
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'description')
  final String? description;

  FileData({
    required this.name,
    required this.bucket,
    required this.path,
    required this.contentType,
    required this.url,
    required this.createdAt,
    this.description,
  });

  factory FileData.fromJson(Map<String, dynamic> json) =>
      _$FileDataFromJson(json);

  Map<String, dynamic> toJson() => _$FileDataToJson(this);
}
