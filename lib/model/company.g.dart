// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  id: json['id'] as String,
  name: json['name'] as String,
  addresses:
      (json['addresses'] as List<dynamic>?)
          ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  businessTaxId: json['business_tax_id'] as String?,
  primaryContact: json['primary_contact'] == null
      ? null
      : User.fromJson(json['primary_contact'] as Map<String, dynamic>),
  primaryContactId: json['primary_contact_id'] as String?,
  isBuyer: json['is_buyer'] as bool?,
  isSeller: json['is_seller'] as bool?,
  confirmationEmail: json['confirmation_email'] as String?,
  businessDunsNumber: json['business_duns_number'] as String?,
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'confirmation_email': instance.confirmationEmail,
  'addresses': instance.addresses.map((e) => e.toJson()).toList(),
  'business_tax_id': instance.businessTaxId,
  'business_duns_number': instance.businessDunsNumber,
  'primary_contact_id': instance.primaryContactId,
  'is_buyer': instance.isBuyer,
  'is_seller': instance.isSeller,
};
