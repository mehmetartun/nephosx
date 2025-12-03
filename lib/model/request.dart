import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'conversions.dart';
import 'enums.dart';

part 'request.g.dart';

@JsonSerializable(explicitToJson: true)
class Request {
  final String id;
  @JsonKey(name: 'requestor_id')
  final String requestorId;
  @JsonKey(name: 'approver_id')
  final String? approverId;
  @JsonKey(name: 'target_company_id')
  final String? targetCompanyId;
  @JsonKey(name: 'target_user_id')
  final String? targetUserId;
  @JsonKey(name: 'target_datacenter_id')
  final String? targetDatacenterId;
  @JsonKey(name: 'target_gpu_cluster_id')
  final String? targetGpuClusterId;
  @JsonKey(name: 'request_date')
  @TimestampConverter()
  final DateTime requestDate;
  @JsonKey(name: 'request_type')
  final RequestType requestType;
  @JsonKey(name: 'decision_date')
  @TimestampConverter()
  final DateTime? decisionDate;
  @JsonKey(name: 'status')
  final RequestStatus status;
  final String? comment;
  final String? summary;

  Request({
    required this.id,
    required this.requestorId,
    this.approverId,
    required this.requestDate,
    this.decisionDate,
    this.status = RequestStatus.pending,
    this.targetCompanyId,
    this.targetUserId,
    this.targetDatacenterId,
    this.targetGpuClusterId,
    required this.requestType,
    this.comment,
    this.summary,
  });

  Request copyWith({
    String? id,
    String? requestorId,
    String? approverId,
    String? targetCompanyId,
    String? targetUserId,
    String? targetDatacenterId,
    String? targetGpuClusterId,
    DateTime? requestDate,
    DateTime? decisionDate,
    RequestStatus? status,
    String? comment,
    String? summary,
    RequestType? requestType,
  }) {
    return Request(
      id: id ?? this.id,
      requestorId: requestorId ?? this.requestorId,
      approverId: approverId ?? this.approverId,
      targetCompanyId: targetCompanyId ?? this.targetCompanyId,
      targetUserId: targetUserId ?? this.targetUserId,
      targetDatacenterId: targetDatacenterId ?? this.targetDatacenterId,
      targetGpuClusterId: targetGpuClusterId ?? this.targetGpuClusterId,
      requestDate: requestDate ?? this.requestDate,
      decisionDate: decisionDate ?? this.decisionDate,
      status: status ?? this.status,
      comment: comment ?? this.comment,
      summary: summary ?? this.summary,
      requestType: requestType ?? this.requestType,
    );
  }

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}
