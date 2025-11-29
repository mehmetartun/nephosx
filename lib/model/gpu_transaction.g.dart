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
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      startDate: const TimestampConverter().fromJson(
        json['startDate'] as Timestamp,
      ),
      endDate: const TimestampConverter().fromJson(
        json['endDate'] as Timestamp,
      ),
      consideration: Consideration.fromJson(
        json['consideration'] as Map<String, dynamic>,
      ),
      datacenterId: json['datacenter_id'] as String,
    );

Map<String, dynamic> _$GpuTransactionToJson(GpuTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'buyer_company_id': instance.buyerCompanyId,
      'gpu_cluster_id': instance.gpuClusterId,
      'datacenter_id': instance.datacenterId,
      'seller_company_id': instance.sellerCompanyId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'startDate': const TimestampConverter().toJson(instance.startDate),
      'endDate': const TimestampConverter().toJson(instance.endDate),
      'consideration': instance.consideration.toJson(),
    };
