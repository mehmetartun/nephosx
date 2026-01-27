// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpu_maintenance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpuMaintenance _$GpuMaintenanceFromJson(Map<String, dynamic> json) =>
    GpuMaintenance(
      id: json['id'] as String,
      gpuClusterId: json['gpu_cluster_id'] as String,
      startDate: const TimestampToEpochConverter().fromJson(
        json['start_date'] as Object,
      ),
      endDate: const TimestampToEpochConverter().fromJson(
        json['end_date'] as Object,
      ),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$GpuMaintenanceToJson(
  GpuMaintenance instance,
) => <String, dynamic>{
  'id': instance.id,
  'gpu_cluster_id': instance.gpuClusterId,
  'start_date': const TimestampToEpochConverter().toJson(instance.startDate),
  'end_date': const TimestampToEpochConverter().toJson(instance.endDate),
  'description': instance.description,
};
