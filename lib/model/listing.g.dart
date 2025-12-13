// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listing _$ListingFromJson(Map<String, dynamic> json) => Listing(
  id: json['id'] as String,
  createdAt: const TimestampToEpochConverter().fromJson(
    json['created_at'] as Object,
  ),
  startDate: const TimestampToEpochConverter().fromJson(
    json['start_date'] as Object,
  ),
  endDate: const TimestampToEpochConverter().fromJson(
    json['end_date'] as Object,
  ),
  companyId: json['company_id'] as String,
  datacenterId: json['datacenter_id'] as String,
  gpuClusterId: json['gpu_cluster_id'] as String,
  rentalPrices: (json['rental_prices'] as List<dynamic>)
      .map((e) => RentalPrice.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: $enumDecode(_$ListingStatusEnumMap, json['status']),
);

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': const TimestampToEpochConverter().toJson(instance.createdAt),
  'start_date': const TimestampToEpochConverter().toJson(instance.startDate),
  'end_date': const TimestampToEpochConverter().toJson(instance.endDate),
  'company_id': instance.companyId,
  'datacenter_id': instance.datacenterId,
  'gpu_cluster_id': instance.gpuClusterId,
  'rental_prices': instance.rentalPrices.map((e) => e.toJson()).toList(),
  'status': _$ListingStatusEnumMap[instance.status]!,
};

const _$ListingStatusEnumMap = {
  ListingStatus.active: 'active',
  ListingStatus.traded: 'traded',
  ListingStatus.expired: 'expired',
  ListingStatus.cancelled: 'cancelled',
};
