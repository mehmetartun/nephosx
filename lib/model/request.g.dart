// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
  id: json['id'] as String,
  requestorId: json['requestor_id'] as String,
  approverId: json['approver_id'] as String?,
  requestDate: const TimestampConverter().fromJson(
    json['request_date'] as Timestamp,
  ),
  decisionDate: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['decision_date'],
    const TimestampConverter().fromJson,
  ),
  status:
      $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
      RequestStatus.pending,
  targetCompanyId: json['target_company_id'] as String?,
  targetUserId: json['target_user_id'] as String?,
  targetDatacenterId: json['target_datacenter_id'] as String?,
  targetGpuClusterId: json['target_gpu_cluster_id'] as String?,
  requestType: $enumDecode(_$RequestTypeEnumMap, json['request_type']),
);

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
  'id': instance.id,
  'requestor_id': instance.requestorId,
  'approver_id': instance.approverId,
  'target_company_id': instance.targetCompanyId,
  'target_user_id': instance.targetUserId,
  'target_datacenter_id': instance.targetDatacenterId,
  'target_gpu_cluster_id': instance.targetGpuClusterId,
  'request_date': const TimestampConverter().toJson(instance.requestDate),
  'request_type': _$RequestTypeEnumMap[instance.requestType]!,
  'decision_date': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.decisionDate,
    const TimestampConverter().toJson,
  ),
  'status': _$RequestStatusEnumMap[instance.status]!,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.inReview: 'in_review',
  RequestStatus.accepted: 'accepted',
  RequestStatus.rejected: 'rejected',
};

const _$RequestTypeEnumMap = {
  RequestType.createCompany: 'create_company',
  RequestType.joinCompany: 'join_company',
  RequestType.authorizeCompany: 'authorize_company',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
