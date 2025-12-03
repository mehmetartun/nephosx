// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  id: json['id'] as String?,
  parentId: json['parentId'] as String?,
  addressLine1: json['addressLine1'] as String,
  addressLine2: json['addressLine2'] as String?,
  zipCode: json['zipCode'] as String,
  city: json['city'] as String,
  state: $enumDecodeNullable(_$AddressStateEnumMap, json['state']),
  country: $enumDecode(_$CountryEnumMap, json['country']),
  addressLine3: json['addressLine3'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'addressLine1': instance.addressLine1,
  'addressLine2': instance.addressLine2,
  'addressLine3': instance.addressLine3,
  'zipCode': instance.zipCode,
  'city': instance.city,
  'state': _$AddressStateEnumMap[instance.state],
  'country': _$CountryEnumMap[instance.country]!,
  'description': instance.description,
};

const _$AddressStateEnumMap = {
  AddressState.bcca: 'bcca',
  AddressState.caus: 'caus',
  AddressState.azus: 'azus',
};

const _$CountryEnumMap = {
  Country.us: 'us',
  Country.ca: 'ca',
  Country.au: 'au',
  Country.nz: 'nz',
  Country.uk: 'uk',
  Country.fr: 'fr',
  Country.de: 'de',
  Country.se: 'se',
  Country.no: 'no',
  Country.dk: 'dk',
  Country.fi: 'fi',
  Country.be: 'be',
  Country.nl: 'nl',
  Country.at: 'at',
  Country.ch: 'ch',
  Country.lu: 'lu',
  Country.hr: 'hr',
  Country.si: 'si',
  Country.sk: 'sk',
  Country.hu: 'hu',
  Country.ro: 'ro',
  Country.bg: 'bg',
  Country.pl: 'pl',
  Country.rs: 'rs',
  Country.cz: 'cz',
  Country.ee: 'ee',
  Country.lv: 'lv',
  Country.lt: 'lt',
  Country.by: 'by',
  Country.md: 'md',
  Country.it: 'it',
  Country.es: 'es',
  Country.pt: 'pt',
};
