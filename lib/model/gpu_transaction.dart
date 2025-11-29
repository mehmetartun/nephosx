import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/model/conversions.dart';

import '../extensions/add_month.dart';
import 'consideration.dart';

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
  @TimestampConverter()
  final DateTime createdAt;
  @TimestampConverter()
  final DateTime startDate;
  @TimestampConverter()
  final DateTime endDate;
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

  factory GpuTransaction.fromJson(Map<String, dynamic> json) =>
      _$GpuTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$GpuTransactionToJson(this);

  bool occupiedDuringMonth(DateTime month) {
    return startDate.addMonths(-1).isBefore(month) && endDate.isAfter(month);
  }

  @override
  String toString() {
    return 'GpuTransaction(from: $startDate, to: $endDate)';
  }
}
