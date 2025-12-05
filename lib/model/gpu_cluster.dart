import 'package:json_annotation/json_annotation.dart';

import 'company.dart';
import 'datacenter.dart';
import 'gpu_transaction.dart';
import 'rental_price.dart';

part 'gpu_cluster.g.dart';

enum GpuType { H100, H200, A100, B200, MI300X, Gaudi3 }

@JsonSerializable(explicitToJson: true)
class GpuCluster {
  final GpuType type;
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
  @JsonKey(name: "per_gpu_ram_in_gb")
  final double? perGpuVramInGb;
  @JsonKey(name: "tera_flops")
  final double? teraFlops;
  @JsonKey(name: "rental_prices")
  final List<RentalPrice> rentalPrices;

  GpuCluster({
    required this.type,
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
  });
  factory GpuCluster.fromJson(Map<String, dynamic> json) =>
      _$GpuClusterFromJson(json);

  Map<String, dynamic> toJson() => _$GpuClusterToJson(this);

  GpuCluster copyWith({
    GpuType? type,
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
  }) {
    return GpuCluster(
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
    );
  }
}
