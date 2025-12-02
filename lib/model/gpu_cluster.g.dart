// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpu_cluster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpuCluster _$GpuClusterFromJson(Map<String, dynamic> json) => GpuCluster(
  type: $enumDecode(_$GpuTypeEnumMap, json['type']),
  quantity: (json['quantity'] as num).toInt(),
  datacenterId: json['datacenter_id'] as String,
  companyId: json['company_id'] as String,
  id: json['id'] as String,
  transactions: (json['transactions'] as List<dynamic>?)
      ?.map((e) => GpuTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
  datacenter: json['datacenter'] == null
      ? null
      : Datacenter.fromJson(json['datacenter'] as Map<String, dynamic>),
  company: json['company'] == null
      ? null
      : Company.fromJson(json['company'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GpuClusterToJson(GpuCluster instance) =>
    <String, dynamic>{
      'type': _$GpuTypeEnumMap[instance.type]!,
      'quantity': instance.quantity,
      'id': instance.id,
      'datacenter_id': instance.datacenterId,
      'company_id': instance.companyId,
    };

const _$GpuTypeEnumMap = {
  GpuType.H100: 'H100',
  GpuType.H200: 'H200',
  GpuType.A100: 'A100',
  GpuType.B200: 'B200',
  GpuType.MI300X: 'MI300X',
  GpuType.Gaudi3: 'Gaudi3',
};
