import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import '../services/platform_settings/platform_settings_service.dart';
import 'company.dart';
import 'conversions.dart';
import 'datacenter.dart';
import 'device.dart';
import 'gpu_transaction.dart';
import 'producer.dart';
import 'rental_price.dart';

part 'gpu_cluster.g.dart';

enum GpuType { H100, H200, A100, B200, MI300X, Gaudi3 }

@JsonEnum(fieldRename: FieldRename.snake)
enum PcieGeneration {
  x1("PCIe 1", 2.5, 1, 4, 2, 1, 0.5, 0.25),
  x2("PCIe 2", 5, 2, 8, 4, 2, 1, 0.5),
  x3("PCIe 3", 8, 3, 15.754, 7.877, 3.938, 1.969, 0.985),
  x4("PCIe 4", 16, 4, 30.25, 15.125, 7.877, 3.938, 1.969),
  x5("PCIe 5", 32, 5, 60.5, 30.25, 15.125, 7.563, 3.938),
  x6("PCIe 6", 64, 6, 121.0, 60.5, 30.25, 15.125, 7.563),
  x7("PCIe 7", 128, 7, 242.0, 121.0, 60.5, 30.25, 15.125);

  const PcieGeneration(
    this.description,
    this.dataRatePerLaneInGtPerSec,
    this.bandWidthPerLaneInGbPerSec,
    this.totalBandwithPer16InGbPerSec,
    this.totalBandwithPer8InGbPerSec,
    this.totalBandwithPer4InGbPerSec,
    this.totalBandwithPer2InGbPerSec,
    this.totalBandwithPer1InGbPerSec,
  );

  final String description;
  final double dataRatePerLaneInGtPerSec;
  final double bandWidthPerLaneInGbPerSec;
  final double totalBandwithPer16InGbPerSec;
  final double totalBandwithPer8InGbPerSec;
  final double totalBandwithPer4InGbPerSec;
  final double totalBandwithPer2InGbPerSec;
  final double totalBandwithPer1InGbPerSec;
}

@JsonSerializable(explicitToJson: true)
class GpuCluster {
  final GpuType? type;
  // @JsonKey(name: "producer_id")
  // final String producerId;
  @JsonKey(name: "device_id")
  final String deviceId;
  final int quantity;
  final String id;
  @JsonKey(name: "datacenter_id")
  final String datacenterId;
  @JsonKey(name: "company_id")
  final String companyId;
  @JsonKey(name: "transactions", includeToJson: false, includeFromJson: true)
  final List<GpuTransaction>? transactions;
  @JsonKey(name: "datacenter", includeToJson: false, includeFromJson: true)
  final Datacenter? datacenter;
  @JsonKey(name: "company", includeToJson: false, includeFromJson: true)
  final Company? company;
  @JsonKey(name: "per_gpu_vram_in_gb")
  final double? perGpuVramInGb;
  @JsonKey(name: "per_gpu_memory_bandwidth_in_gb_per_sec")
  final double? perGpuMemoryBandwidthInGbPerSec;
  @JsonKey(name: "per_gpu_nv_link_bandwidth_in_gb_per_sec")
  final double? perGpuNvLinkBandwidthInGbPerSec;
  @JsonKey(name: "tera_flops")
  final double? teraFlops;
  @JsonKey(name: "rental_prices")
  final List<RentalPrice> rentalPrices;
  @JsonKey(name: "pcie_generation")
  final PcieGeneration? pcieGeneration;
  @JsonKey(name: "pcie_lanes")
  final int? pcieLanes;
  @JsonKey(name: "per_gpu_pcie_bandwidth_in_gb_per_sec")
  final double? perGpuPcieBandwidthInGbPerSec;
  @JsonKey(name: "maximum_cuda_version_supported")
  final String? maximumCudaVersionSupported;
  @JsonKey(name: "effective_ram")
  final double? effectiveRam;
  @JsonKey(name: "total_ram")
  final double? totalRam;
  @JsonKey(name: "total_cpu_core_count")
  final int? totalCpuCoreCount;
  @JsonKey(name: "effective_cpu_core_count")
  final int? effectiveCpuCoreCount;
  @JsonKey(name: "internet_upload_speed_in_mbps")
  final double? internetUploadSpeedInMbps;
  @JsonKey(name: "internet_download_speed_in_mbps")
  final double? internetDownloadSpeedInMbps;
  @JsonKey(name: "number_of_open_ports")
  final int? numberOfOpenPorts;
  @JsonKey(name: "disk_bandwidth_in_mb_per_sec")
  final double? diskBandwidthInMbPerSec;
  @JsonKey(name: "disk_storage_available_in_gb")
  final double? diskStorageAvailableInGb;
  @JsonKey(name: "deep_learning_performance_score")
  final double? deepLearningPerformanceScore;
  @JsonKey(name: "availability_date")
  @TimestampConverter()
  final DateTime? availabilityDate;

  GpuCluster({
    // required this.producerId,
    required this.deviceId,
    this.pcieGeneration,
    this.pcieLanes,
    this.perGpuPcieBandwidthInGbPerSec,
    this.maximumCudaVersionSupported,
    this.type,
    this.perGpuMemoryBandwidthInGbPerSec,
    this.perGpuNvLinkBandwidthInGbPerSec,
    required this.quantity,
    required this.datacenterId,
    required this.companyId,
    required this.id,
    this.perGpuVramInGb,
    this.transactions,
    this.datacenter,
    this.company,
    this.teraFlops,
    this.rentalPrices = const [],
    this.effectiveRam,
    this.totalRam,
    this.totalCpuCoreCount,
    this.effectiveCpuCoreCount,
    this.internetUploadSpeedInMbps,
    this.internetDownloadSpeedInMbps,
    this.numberOfOpenPorts,
    this.diskBandwidthInMbPerSec,
    this.diskStorageAvailableInGb,
    this.deepLearningPerformanceScore,
    this.availabilityDate,
  });
  factory GpuCluster.fromJson(Map<String, dynamic> json) =>
      _$GpuClusterFromJson(json);

  Map<String, dynamic> toJson() => _$GpuClusterToJson(this);

  GpuCluster copyWith({
    // String? producerId,
    String? deviceId,
    PcieGeneration? pcieGeneration,
    int? pcieLanes,
    double? perGpuPcieBandwidthInGbPerSec,
    String? maximumCudaVersionSupported,
    GpuType? type,
    double? perGpuMemoryBandwidthInGbPerSec,
    double? perGpuNvLinkBandwidthInGbPerSec,
    int? quantity,
    String? datacenterId,
    Datacenter? datacenter,
    Company? company,
    String? companyId,
    String? id,
    double? perGpuVramInGb,
    List<GpuTransaction>? transactions,
    double? teraFlops,
    List<RentalPrice>? rentalPrices,
    double? effectiveRam,
    double? totalRam,
    int? totalCpuCoreCount,
    int? effectiveCpuCoreCount,
    double? internetUploadSpeedInMbps,
    double? internetDownloadSpeedInMbps,
    int? numberOfOpenPorts,
    double? diskBandwidthInMbPerSec,
    double? diskStorageAvailableInGb,
    double? deepLearningPerformanceScore,
    DateTime? availabilityDate,
  }) {
    return GpuCluster(
      // producerId: producerId ?? this.producerId,
      deviceId: deviceId ?? this.deviceId,
      pcieGeneration: pcieGeneration ?? this.pcieGeneration,
      pcieLanes: pcieLanes ?? this.pcieLanes,
      perGpuPcieBandwidthInGbPerSec:
          perGpuPcieBandwidthInGbPerSec ?? this.perGpuPcieBandwidthInGbPerSec,
      maximumCudaVersionSupported:
          maximumCudaVersionSupported ?? this.maximumCudaVersionSupported,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      datacenterId: datacenterId ?? this.datacenterId,
      companyId: companyId ?? this.companyId,
      id: id ?? this.id,
      perGpuVramInGb: perGpuVramInGb ?? this.perGpuVramInGb,
      transactions: transactions ?? this.transactions,
      datacenter: datacenter ?? this.datacenter,
      company: company ?? this.company,
      teraFlops: teraFlops ?? this.teraFlops,
      rentalPrices: rentalPrices ?? this.rentalPrices,
      perGpuNvLinkBandwidthInGbPerSec:
          perGpuNvLinkBandwidthInGbPerSec ??
          this.perGpuNvLinkBandwidthInGbPerSec,
      perGpuMemoryBandwidthInGbPerSec:
          perGpuMemoryBandwidthInGbPerSec ??
          this.perGpuMemoryBandwidthInGbPerSec,
      effectiveRam: effectiveRam ?? this.effectiveRam,
      totalRam: totalRam ?? this.totalRam,
      totalCpuCoreCount: totalCpuCoreCount ?? this.totalCpuCoreCount,
      effectiveCpuCoreCount:
          effectiveCpuCoreCount ?? this.effectiveCpuCoreCount,
      internetUploadSpeedInMbps:
          internetUploadSpeedInMbps ?? this.internetUploadSpeedInMbps,
      internetDownloadSpeedInMbps:
          internetDownloadSpeedInMbps ?? this.internetDownloadSpeedInMbps,
      numberOfOpenPorts: numberOfOpenPorts ?? this.numberOfOpenPorts,
      diskBandwidthInMbPerSec:
          diskBandwidthInMbPerSec ?? this.diskBandwidthInMbPerSec,
      diskStorageAvailableInGb:
          diskStorageAvailableInGb ?? this.diskStorageAvailableInGb,
      deepLearningPerformanceScore:
          deepLearningPerformanceScore ?? this.deepLearningPerformanceScore,
      availabilityDate: availabilityDate ?? this.availabilityDate,
    );
  }

  Device? get device {
    return PlatformSettingsService.instance.platformSettings.devices
        .firstWhereOrNull((e) {
          return e.id == deviceId;
        });
  }

  Producer? get producer {
    Device? d = device;
    if (d == null) return null;
    return PlatformSettingsService.instance.platformSettings.producers
        .firstWhereOrNull((e) {
          return e.id == d.producerId;
        });
  }

  static GpuCluster? getGpuClusterById(
    List<GpuCluster> gpuClusters,
    String gpuClusterId,
  ) {
    return gpuClusters.firstWhereOrNull((e) {
      return e.id == gpuClusterId;
    });
  }
}
