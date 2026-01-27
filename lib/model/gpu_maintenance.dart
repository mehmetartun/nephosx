import 'package:json_annotation/json_annotation.dart';

import 'conversions.dart';
import 'slot.dart';

part 'gpu_maintenance.g.dart';

@JsonSerializable(explicitToJson: true)
class GpuMaintenance {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "gpu_cluster_id")
  final String gpuClusterId;
  @JsonKey(name: "start_date")
  @TimestampToEpochConverter()
  final DateTime startDate;
  @JsonKey(name: "end_date")
  @TimestampToEpochConverter()
  final DateTime endDate;
  @JsonKey(name: "description")
  final String? description;

  GpuMaintenance({
    required this.id,
    required this.gpuClusterId,
    required this.startDate,
    required this.endDate,
    this.description,
  });

  Slot get slot => Slot(from: startDate, to: endDate);

  factory GpuMaintenance.fromJson(Map<String, dynamic> json) =>
      _$GpuMaintenanceFromJson(json);

  Map<String, dynamic> toJson() => _$GpuMaintenanceToJson(this);
}
