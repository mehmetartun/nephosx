import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/model/company.dart';
import 'package:nephosx/model/datacenter.dart';
import 'package:nephosx/model/gpu_cluster.dart';
import 'package:nephosx/model/rental_price.dart';

import 'conversions.dart';
import 'slot.dart';

part 'listing.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ListingStatus { active, traded, expired, cancelled }

@JsonSerializable(explicitToJson: true)
class Listing {
  final String id;
  @TimestampToEpochConverter()
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @TimestampToEpochConverter()
  @JsonKey(name: "start_date")
  final DateTime startDate;
  @TimestampToEpochConverter()
  @JsonKey(name: "end_date")
  final DateTime endDate;
  @JsonKey(name: "company_id")
  final String companyId;
  @JsonKey(name: "datacenter_id")
  final String datacenterId;
  @JsonKey(name: "gpu_cluster_id")
  final String gpuClusterId;
  @JsonKey(name: "gpu_cluster", includeToJson: false, includeFromJson: false)
  GpuCluster? gpuCluster;
  @JsonKey(name: "datacenter", includeToJson: false, includeFromJson: false)
  Datacenter? datacenter;
  @JsonKey(name: "company", includeToJson: false, includeFromJson: false)
  Company? company;
  @JsonKey(name: "rental_prices")
  final List<RentalPrice> rentalPrices;
  @JsonKey(name: "status")
  final ListingStatus status;

  Listing({
    required this.id,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.companyId,
    required this.datacenterId,
    required this.gpuClusterId,
    this.gpuCluster,
    required this.rentalPrices,
    required this.status,
  });

  Listing copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    String? companyId,
    String? datacenterId,
    String? gpuClusterId,
    GpuCluster? gpuCluster,
    List<RentalPrice>? rentalPrices,
    ListingStatus? status,
  }) {
    return Listing(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      companyId: companyId ?? this.companyId,
      datacenterId: datacenterId ?? this.datacenterId,
      gpuClusterId: gpuClusterId ?? this.gpuClusterId,
      gpuCluster: gpuCluster ?? this.gpuCluster,
      rentalPrices: rentalPrices ?? this.rentalPrices,
      status: status ?? this.status,
    );
  }

  void addGpuCluster(List<GpuCluster> gpuClusters) {
    gpuCluster = gpuClusters.firstWhereOrNull(
      (element) => element.id == gpuClusterId,
    );
  }

  void addDatacenter(List<Datacenter> datacenters) {
    datacenter = datacenters.firstWhereOrNull(
      (element) => element.id == datacenterId,
    );
  }

  Slot get slot => Slot(from: startDate, to: endDate);

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);

  Map<String, dynamic> toJson() => _$ListingToJson(this);
}
