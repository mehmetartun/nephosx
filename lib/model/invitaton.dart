import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'conversions.dart';

part 'invitaton.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum InvitationStatus { invited, accepted, rejected }

@JsonSerializable(explicitToJson: true)
class Invitation {
  final String id;
  final String email;
  @JsonKey(name: "display_name")
  final String displayName;
  @JsonKey(name: "company_id")
  final String companyId;
  @JsonKey(name: "company_name")
  final String companyName;
  final String message;
  @JsonKey(name: "mail_record_id")
  final String mailRecordId;
  final InvitationStatus status;
  @JsonKey(name: "created_at")
  @TimestampConverter()
  final DateTime createdAt;

  Invitation({
    required this.id,
    required this.email,
    required this.displayName,
    required this.companyId,
    required this.companyName,
    required this.message,
    required this.mailRecordId,
    required this.status,
    required this.createdAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) =>
      _$InvitationFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationToJson(this);
}
