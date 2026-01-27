// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Portfolio _$PortfolioFromJson(Map<String, dynamic> json) => Portfolio(
  name: json['name'] as String,
  description: json['description'] as String,
  transactions:
      (json['transactions'] as List<dynamic>?)
          ?.map((e) => GpuTransaction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  transactionIds: (json['transaction_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PortfolioToJson(Portfolio instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'transaction_ids': instance.transactionIds,
  'transactions': instance.transactions.map((e) => e.toJson()).toList(),
};
