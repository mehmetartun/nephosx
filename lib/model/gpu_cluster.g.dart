// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpu_cluster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpuCluster _$GpuClusterFromJson(Map<String, dynamic> json) => GpuCluster(
  pcieGeneration: $enumDecodeNullable(
    _$PcieGenerationEnumMap,
    json['pcie_generation'],
  ),
  pcieLanes: (json['pcie_lanes'] as num?)?.toInt(),
  perGpuPcieBandwidthInGbPerSec:
      (json['per_gpu_pcie_bandwidth_in_gb_per_sec'] as num?)?.toDouble(),
  maximumCudaVersionSupported:
      json['maximum_cuda_version_supported'] as String?,
  type: $enumDecode(_$GpuTypeEnumMap, json['type']),
  perGpuMemoryBandwidthInGbPerSec:
      (json['per_gpu_memory_bandwidth_in_gb_per_sec'] as num?)?.toDouble(),
  perGpuNvLinkBandwidthInGbPerSec:
      (json['per_gpu_nv_link_bandwidth_in_gb_per_sec'] as num?)?.toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  datacenterId: json['datacenter_id'] as String,
  companyId: json['company_id'] as String,
  id: json['id'] as String,
  perGpuVramInGb: (json['per_gpu_vram_in_gb'] as num?)?.toDouble(),
  transactions: (json['transactions'] as List<dynamic>?)
      ?.map((e) => GpuTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
  datacenter: json['datacenter'] == null
      ? null
      : Datacenter.fromJson(json['datacenter'] as Map<String, dynamic>),
  company: json['company'] == null
      ? null
      : Company.fromJson(json['company'] as Map<String, dynamic>),
  teraFlops: (json['tera_flops'] as num?)?.toDouble(),
  rentalPrices:
      (json['rental_prices'] as List<dynamic>?)
          ?.map((e) => RentalPrice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  effectiveRam: (json['effective_ram'] as num?)?.toDouble(),
  totalRam: (json['total_ram'] as num?)?.toDouble(),
  totalCpuCoreCount: (json['total_cpu_core_count'] as num?)?.toInt(),
  effectiveCpuCoreCount: (json['effective_cpu_core_count'] as num?)?.toInt(),
  internetUploadSpeedInMbps: (json['internet_upload_speed_in_mbps'] as num?)
      ?.toDouble(),
  internetDownloadSpeedInMbps: (json['internet_download_speed_in_mbps'] as num?)
      ?.toDouble(),
  numberOfOpenPorts: (json['number_of_open_ports'] as num?)?.toInt(),
  diskBandwidthInMbPerSec: (json['disk_bandwidth_in_mb_per_sec'] as num?)
      ?.toDouble(),
  diskStorageAvailableInGb: (json['disk_storage_available_in_gb'] as num?)
      ?.toDouble(),
  deepLearningPerformanceScore:
      (json['deep_learning_performance_score'] as num?)?.toDouble(),
  availabilityDate: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['availability_date'],
    const TimestampConverter().fromJson,
  ),
);

Map<String, dynamic> _$GpuClusterToJson(GpuCluster instance) =>
    <String, dynamic>{
      'type': _$GpuTypeEnumMap[instance.type]!,
      'quantity': instance.quantity,
      'id': instance.id,
      'datacenter_id': instance.datacenterId,
      'company_id': instance.companyId,
      'per_gpu_vram_in_gb': instance.perGpuVramInGb,
      'per_gpu_memory_bandwidth_in_gb_per_sec':
          instance.perGpuMemoryBandwidthInGbPerSec,
      'per_gpu_nv_link_bandwidth_in_gb_per_sec':
          instance.perGpuNvLinkBandwidthInGbPerSec,
      'tera_flops': instance.teraFlops,
      'rental_prices': instance.rentalPrices.map((e) => e.toJson()).toList(),
      'pcie_generation': _$PcieGenerationEnumMap[instance.pcieGeneration],
      'pcie_lanes': instance.pcieLanes,
      'per_gpu_pcie_bandwidth_in_gb_per_sec':
          instance.perGpuPcieBandwidthInGbPerSec,
      'maximum_cuda_version_supported': instance.maximumCudaVersionSupported,
      'effective_ram': instance.effectiveRam,
      'total_ram': instance.totalRam,
      'total_cpu_core_count': instance.totalCpuCoreCount,
      'effective_cpu_core_count': instance.effectiveCpuCoreCount,
      'internet_upload_speed_in_mbps': instance.internetUploadSpeedInMbps,
      'internet_download_speed_in_mbps': instance.internetDownloadSpeedInMbps,
      'number_of_open_ports': instance.numberOfOpenPorts,
      'disk_bandwidth_in_mb_per_sec': instance.diskBandwidthInMbPerSec,
      'disk_storage_available_in_gb': instance.diskStorageAvailableInGb,
      'deep_learning_performance_score': instance.deepLearningPerformanceScore,
      'availability_date': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.availabilityDate,
        const TimestampConverter().toJson,
      ),
    };

const _$PcieGenerationEnumMap = {
  PcieGeneration.x1: 'x1',
  PcieGeneration.x2: 'x2',
  PcieGeneration.x3: 'x3',
  PcieGeneration.x4: 'x4',
  PcieGeneration.x5: 'x5',
  PcieGeneration.x6: 'x6',
  PcieGeneration.x7: 'x7',
};

const _$GpuTypeEnumMap = {
  GpuType.H100: 'H100',
  GpuType.H200: 'H200',
  GpuType.A100: 'A100',
  GpuType.B200: 'B200',
  GpuType.MI300X: 'MI300X',
  GpuType.Gaudi3: 'Gaudi3',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
