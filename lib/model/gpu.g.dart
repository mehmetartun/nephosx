// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gpu _$GpuFromJson(Map<String, dynamic> json) => Gpu(
  type: $enumDecode(_$GpuTypeEnumMap, json['type']),
  quantity: (json['quantity'] as num).toInt(),
  datacenterId: json['datacenter_id'] as String,
  companyId: json['company_id'] as String,
  id: json['id'] as String,
);

Map<String, dynamic> _$GpuToJson(Gpu instance) => <String, dynamic>{
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
