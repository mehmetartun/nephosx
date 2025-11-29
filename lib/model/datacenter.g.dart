// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datacenter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datacenter _$DatacenterFromJson(Map<String, dynamic> json) => Datacenter(
  id: json['id'] as String,
  name: json['name'] as String,
  companyId: json['company_id'] as String,
  tier: $enumDecode(_$DatacenterTierEnumMap, json['tier']),
  country: json['country'] as String,
  region: json['region'] as String,
);

Map<String, dynamic> _$DatacenterToJson(Datacenter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'company_id': instance.companyId,
      'country': instance.country,
      'region': instance.region,
      'tier': _$DatacenterTierEnumMap[instance.tier]!,
    };

const _$DatacenterTierEnumMap = {
  DatacenterTier.tier1: 'tier1',
  DatacenterTier.tier2: 'tier2',
  DatacenterTier.tier3: 'tier3',
  DatacenterTier.tier4: 'tier4',
};
