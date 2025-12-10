import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'conversions.dart';
import 'enums.dart';

part 'request.g.dart';

@JsonSerializable(explicitToJson: true)
class Request {
  final String id;
  final RequestType type;
  final RequestStatus status;
  final Map<String, dynamic> data;
  @TimestampConverter()
  @JsonKey(name: "request_date")
  final DateTime requestDate;

  Request({
    required this.id,
    required this.type,
    required this.status,
    required this.data,
    required this.requestDate,
  });

  Request copyWith({
    String? id,
    RequestType? type,
    RequestStatus? status,
    Map<String, dynamic>? data,
    DateTime? requestDate,
  }) {
    return Request(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      data: data ?? this.data,
      requestDate: requestDate ?? this.requestDate,
    );
  }

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}
