import 'package:json_annotation/json_annotation.dart';

import 'consideration.dart';
import 'enums.dart';
import 'gpu_transaction.dart';
import 'portfolio_summary.dart';

part 'portfolio.g.dart';

@JsonSerializable(explicitToJson: true)
class Portfolio {
  final String name;
  final String description;
  @JsonKey(name: 'transaction_ids')
  final List<String> transactionIds;
  List<GpuTransaction> transactions;

  Portfolio({
    required this.name,
    required this.description,
    this.transactions = const [],
    required this.transactionIds,
  });

  Portfolio copyWith({
    String? name,
    String? description,
    List<GpuTransaction>? transactions,
    List<String>? transactionIds,
  }) {
    return Portfolio(
      name: name ?? this.name,
      description: description ?? this.description,
      transactions: transactions ?? this.transactions,
      transactionIds: transactionIds ?? this.transactionIds,
    );
  }

  PortfolioSummary get summary {
    return PortfolioSummary(
      portfolioName: name,
      portfolioDescription: description,
      totalReceivable: Consideration(amount: 2000000.0, currency: Currency.usd),
      offerPrice: Consideration(amount: 1800000.0, currency: Currency.usd),
      averageSPRating: "A+",
      averageMoodysRating: "A",
      averageFitchRating: "A+",
      averageCreditRating: "A+",
      totalTransactions: transactions.length,
    );
  }

  factory Portfolio.fromJson(Map<String, dynamic> json) =>
      _$PortfolioFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioToJson(this);
}

//
