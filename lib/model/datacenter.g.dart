// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datacenter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datacenter _$DatacenterFromJson(Map<String, dynamic> json) => Datacenter(
  id: json['id'] as String,
  name: json['name'] as String,
  companyId: json['company_id'] as String,
  address: Address.fromJson(json['address'] as Map<String, dynamic>),
  tier: $enumDecode(_$DatacenterTierEnumMap, json['tier']),
  iso27001: json['iso27001'] as bool? ?? false,
);

Map<String, dynamic> _$DatacenterToJson(Datacenter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'company_id': instance.companyId,
      'address': instance.address.toJson(),
      'tier': _$DatacenterTierEnumMap[instance.tier]!,
      'iso27001': instance.iso27001,
    };

const _$DatacenterTierEnumMap = {
  DatacenterTier.tier1: 'tier1',
  DatacenterTier.tier2: 'tier2',
  DatacenterTier.tier3: 'tier3',
  DatacenterTier.tier4: 'tier4',
};
