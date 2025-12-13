import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/model/conversions.dart';
import 'package:nephosx/model/enums.dart';
import 'package:nephosx/model/enums.dart';

import '../extensions/add_month.dart';
import 'consideration.dart';
import 'slot.dart';

part 'gpu_transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class GpuTransaction {
  final String id;
  @JsonKey(name: "buyer_company_id")
  final String buyerCompanyId;
  @JsonKey(name: "gpu_cluster_id")
  final String gpuClusterId;
  @JsonKey(name: "datacenter_id")
  final String datacenterId;
  @JsonKey(name: "seller_company_id")
  final String sellerCompanyId;
  @JsonKey(name: "created_at")
  @TimestampToEpochConverter()
  final DateTime createdAt;
  @JsonKey(name: "start_date")
  @TimestampToEpochConverter()
  final DateTime startDate;
  @JsonKey(name: "end_date")
  @TimestampToEpochConverter()
  final DateTime endDate;
  @JsonKey(name: "consideration")
  final Consideration consideration;

  GpuTransaction({
    required this.id,
    required this.buyerCompanyId,
    required this.gpuClusterId,
    required this.sellerCompanyId,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.consideration,
    required this.datacenterId,
  });

  Consideration get hourlyRate => Consideration(
    amount: consideration.amount / (endDate.difference(startDate).inHours),
    currency: consideration.currency,
  );

  Slot get slot => Slot(from: startDate, to: endDate);

  factory GpuTransaction.fromJson(Map<String, dynamic> json) =>
      _$GpuTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$GpuTransactionToJson(this);

  bool occupiedDuringMonth(DateTime month) {
    return startDate.addMonths(-1).isBefore(month) && endDate.isAfter(month);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GpuTransaction &&
        other.id == id &&
        other.buyerCompanyId == buyerCompanyId &&
        other.gpuClusterId == gpuClusterId &&
        other.sellerCompanyId == sellerCompanyId &&
        other.createdAt == createdAt &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.consideration == consideration &&
        other.datacenterId == datacenterId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        buyerCompanyId.hashCode ^
        gpuClusterId.hashCode ^
        sellerCompanyId.hashCode ^
        createdAt.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        consideration.hashCode ^
        datacenterId.hashCode;
  }

  @override
  String toString() {
    return 'Txn(id: $id, from: $startDate, to: $endDate)';
  }
}
