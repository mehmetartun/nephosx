import 'package:json_annotation/json_annotation.dart';

import 'gpu_transaction.dart';

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
  final List<GpuTransaction>? transactions;

  GpuCluster({
    required this.type,
    required this.quantity,
    required this.datacenterId,
    required this.companyId,
    required this.id,
    this.transactions,
  });
  factory GpuCluster.fromJson(Map<String, dynamic> json) =>
      _$GpuClusterFromJson(json);

  Map<String, dynamic> toJson() => _$GpuClusterToJson(this);

  GpuCluster copyWith({
    GpuType? type,
    int? quantity,
    String? datacenterId,
    String? companyId,
    String? id,
  }) {
    return GpuCluster(
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      datacenterId: datacenterId ?? this.datacenterId,
      companyId: companyId ?? this.companyId,
      id: id ?? this.id,
    );
  }
}
