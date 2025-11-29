// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consideration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consideration _$ConsiderationFromJson(Map<String, dynamic> json) =>
    Consideration(
      amount: (json['amount'] as num).toDouble(),
      currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
    );

Map<String, dynamic> _$ConsiderationToJson(Consideration instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': _$CurrencyEnumMap[instance.currency]!,
    };

const _$CurrencyEnumMap = {
  Currency.usd: 'usd',
  Currency.eur: 'eur',
  Currency.gbp: 'gbp',
  Currency.jpy: 'jpy',
};
