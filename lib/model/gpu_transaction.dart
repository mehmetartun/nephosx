import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/model/company.dart';
import 'package:nephosx/model/conversions.dart';

import '../extensions/add_month.dart';
import 'consideration.dart';
import 'datacenter.dart';
import 'gpu_cluster.dart';
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
  @JsonKey(name: "counterparty_ids")
  final List<String> counterpartyIds;
  @JsonKey(name: "listing_id")
  final String? listingId;
  @JsonKey(name: "buyer_company", includeFromJson: true, includeToJson: false)
  Company? buyerCompany;
  @JsonKey(name: "seller_company", includeFromJson: true, includeToJson: false)
  Company? sellerCompany;
  @JsonKey(name: "gpu_cluster", includeFromJson: true, includeToJson: false)
  GpuCluster? gpuCluster;
  @JsonKey(name: "datacenter", includeFromJson: true, includeToJson: false)
  Datacenter? datacenter;

  GpuTransaction({
    required this.id,
    required this.buyerCompanyId,
    required this.gpuClusterId,
    required this.sellerCompanyId,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.consideration,
    required this.counterpartyIds,
    this.listingId,
    required this.datacenterId,
    this.buyerCompany,
    this.sellerCompany,
    this.gpuCluster,
    this.datacenter,
  });

  void addDatacenter(List<Datacenter> datacenters) {
    datacenter = datacenters.firstWhereOrNull(
      (element) => element.id == datacenterId,
    );
  }

  void addBuyer(List<Company> companies) {
    buyerCompany = companies.firstWhereOrNull((company) {
      return company.id == buyerCompanyId;
    });
  }

  void addSeller(List<Company> companies) {
    sellerCompany = companies.firstWhereOrNull((company) {
      return company.id == sellerCompanyId;
    });
  }

  void addGpuCluster(List<GpuCluster> gpuClusters) {
    gpuCluster = gpuClusters.firstWhereOrNull((gpuCluster) {
      return gpuCluster.id == gpuClusterId;
    });
  }

  Consideration get hourlyRate => Consideration(
    amount: endDate.difference(startDate).inSeconds == 0
        ? 0
        : consideration.amount /
              (endDate.difference(startDate).inSeconds / (60 * 60)),
    currency: consideration.currency,
  );

  Consideration get dailyRate => Consideration(
    amount: hourlyRate.amount * 24.0,
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
