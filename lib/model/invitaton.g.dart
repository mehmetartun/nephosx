// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitaton.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invitation _$InvitationFromJson(Map<String, dynamic> json) => Invitation(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String,
  companyId: json['company_id'] as String,
  companyName: json['company_name'] as String,
  message: json['message'] as String,
  mailRecordId: json['mail_record_id'] as String,
  status: $enumDecode(_$InvitationStatusEnumMap, json['status']),
  createdAt: const TimestampConverter().fromJson(
    json['created_at'] as Timestamp,
  ),
);

Map<String, dynamic> _$InvitationToJson(Invitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'display_name': instance.displayName,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'message': instance.message,
      'mail_record_id': instance.mailRecordId,
      'status': _$InvitationStatusEnumMap[instance.status]!,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
    };

const _$InvitationStatusEnumMap = {
  InvitationStatus.invited: 'invited',
  InvitationStatus.accepted: 'accepted',
  InvitationStatus.rejected: 'rejected',
};
