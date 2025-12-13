// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpu_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpuTransaction _$GpuTransactionFromJson(Map<String, dynamic> json) =>
    GpuTransaction(
      id: json['id'] as String,
      buyerCompanyId: json['buyer_company_id'] as String,
      gpuClusterId: json['gpu_cluster_id'] as String,
      sellerCompanyId: json['seller_company_id'] as String,
      createdAt: const TimestampToEpochConverter().fromJson(
        json['created_at'] as Object,
      ),
      startDate: const TimestampToEpochConverter().fromJson(
        json['start_date'] as Object,
      ),
      endDate: const TimestampToEpochConverter().fromJson(
        json['end_date'] as Object,
      ),
      consideration: Consideration.fromJson(
        json['consideration'] as Map<String, dynamic>,
      ),
      datacenterId: json['datacenter_id'] as String,
    );

Map<String, dynamic> _$GpuTransactionToJson(
  GpuTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'buyer_company_id': instance.buyerCompanyId,
  'gpu_cluster_id': instance.gpuClusterId,
  'datacenter_id': instance.datacenterId,
  'seller_company_id': instance.sellerCompanyId,
  'created_at': const TimestampToEpochConverter().toJson(instance.createdAt),
  'start_date': const TimestampToEpochConverter().toJson(instance.startDate),
  'end_date': const TimestampToEpochConverter().toJson(instance.endDate),
  'consideration': instance.consideration.toJson(),
};
