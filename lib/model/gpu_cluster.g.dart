// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpu_cluster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpuCluster _$GpuClusterFromJson(Map<String, dynamic> json) => GpuCluster(
  deviceId: json['device_id'] as String,
  cpuId: json['cpu_id'] as String,
  pcieGeneration: $enumDecodeNullable(
    _$PcieGenerationEnumMap,
    json['pcie_generation'],
  ),
  pcieLanes: (json['pcie_lanes'] as num?)?.toInt(),
  perGpuPcieBandwidthInGbPerSec:
      (json['per_gpu_pcie_bandwidth_in_gb_per_sec'] as num?)?.toDouble(),
  maximumCudaVersionSupported:
      json['maximum_cuda_version_supported'] as String?,
  perGpuMemoryBandwidthInGbPerSec:
      (json['per_gpu_memory_bandwidth_in_gb_per_sec'] as num?)?.toDouble(),
  perGpuNvLinkBandwidthInGbPerSec:
      (json['per_gpu_nv_link_bandwidth_in_gb_per_sec'] as num?)?.toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  datacenterId: json['datacenter_id'] as String,
  companyId: json['company_id'] as String,
  id: json['id'] as String,
  perGpuVramInGb: (json['per_gpu_vram_in_gb'] as num?)?.toDouble(),
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
  manufactureDate: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['manufacture_date'],
    const TimestampConverter().fromJson,
  ),
  startDate: const TimestampConverter().fromJson(
    json['start_date'] as Timestamp,
  ),
  endDate: const TimestampConverter().fromJson(json['end_date'] as Timestamp),
);

Map<String, dynamic> _$GpuClusterToJson(GpuCluster instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'cpu_id': instance.cpuId,
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
      'start_date': const TimestampConverter().toJson(instance.startDate),
      'end_date': const TimestampConverter().toJson(instance.endDate),
      'manufacture_date': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.manufactureDate,
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

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
