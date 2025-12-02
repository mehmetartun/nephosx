// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datacenter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datacenter _$DatacenterFromJson(Map<String, dynamic> json) => Datacenter(
  id: json['id'] as String,
  name: json['name'] as String,
  address: Address.fromJson(json['address'] as Map<String, dynamic>),
  tier: $enumDecode(_$DatacenterTierEnumMap, json['tier']),
);

Map<String, dynamic> _$DatacenterToJson(Datacenter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address.toJson(),
      'tier': _$DatacenterTierEnumMap[instance.tier]!,
    };

const _$DatacenterTierEnumMap = {
  DatacenterTier.tier1: 'tier1',
  DatacenterTier.tier2: 'tier2',
  DatacenterTier.tier3: 'tier3',
  DatacenterTier.tier4: 'tier4',
};
