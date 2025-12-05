// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  displayName: json['display_name'] as String?,
  email: json['email'] as String?,
  photoUrl: json['photo_url'] as String?,
  photoBase64: json['photo_base64'] as String?,
  companyId: json['company_id'] as String?,
  uid: json['uid'] as String,
  company: json['company'] == null
      ? null
      : Company.fromJson(json['company'] as Map<String, dynamic>),
  type: $enumDecodeNullable(_$UserTypeEnumMap, json['type']),
  address: json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>),
  emailVerified: json['email_verified'] as bool? ?? false,
  createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['created_at'],
    const TimestampConverter().fromJson,
  ),
  lastLoginAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['last_login_at'],
    const TimestampConverter().fromJson,
  ),
  isAnonymous: json['is_anonymous'] as bool? ?? false,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'display_name': instance.displayName,
  'email': instance.email,
  'email_verified': instance.emailVerified,
  'photo_url': instance.photoUrl,
  'photo_base64': instance.photoBase64,
  'company_id': instance.companyId,
  'uid': instance.uid,
  'type': _$UserTypeEnumMap[instance.type],
  'address': instance.address,
  'is_anonymous': instance.isAnonymous,
};

const _$UserTypeEnumMap = {
  UserType.public: 'public',
  UserType.admin: 'admin',
  UserType.corporate: 'corporate',
  UserType.corporateAdmin: 'corporateAdmin',
  UserType.anonymous: 'anonymous',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);
