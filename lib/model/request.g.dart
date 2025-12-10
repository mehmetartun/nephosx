// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
  id: json['id'] as String,
  type: $enumDecode(_$RequestTypeEnumMap, json['type']),
  status: $enumDecode(_$RequestStatusEnumMap, json['status']),
  data: json['data'] as Map<String, dynamic>,
  requestDate: const TimestampConverter().fromJson(
    json['request_date'] as Timestamp,
  ),
);

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$RequestTypeEnumMap[instance.type]!,
  'status': _$RequestStatusEnumMap[instance.status]!,
  'data': instance.data,
  'request_date': const TimestampConverter().toJson(instance.requestDate),
};

const _$RequestTypeEnumMap = {
  RequestType.createCompany: 'create_company',
  RequestType.joinCompany: 'join_company',
  RequestType.authorizeCompany: 'authorize_company',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.inReview: 'in_review',
  RequestStatus.accepted: 'accepted',
  RequestStatus.rejected: 'rejected',
  RequestStatus.withdrawn: 'withdrawn',
};
