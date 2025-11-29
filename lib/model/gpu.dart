import 'package:json_annotation/json_annotation.dart';

part 'gpu.g.dart';

enum GpuType { H100, H200, A100, B200, MI300X, Gaudi3 }

@JsonSerializable(explicitToJson: true)
class Gpu {
  final GpuType type;
  final int quantity;
  final String id;
  @JsonKey(name: "datacenter_id")
  final String datacenterId;
  @JsonKey(name: "company_id")
  final String companyId;

  Gpu({
    required this.type,
    required this.quantity,
    required this.datacenterId,
    required this.companyId,
    required this.id,
  });
  factory Gpu.fromJson(Map<String, dynamic> json) => _$GpuFromJson(json);

  Map<String, dynamic> toJson() => _$GpuToJson(this);

  Gpu copyWith({
    GpuType? type,
    int? quantity,
    String? datacenterId,
    String? companyId,
    String? id,
  }) {
    return Gpu(
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      datacenterId: datacenterId ?? this.datacenterId,
      companyId: companyId ?? this.companyId,
      id: id ?? this.id,
    );
  }
}
