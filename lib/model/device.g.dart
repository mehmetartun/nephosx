// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) {
  print(json);
  return Device(
    id: json['id'] as String,
    name: json['name'] as String,
    producerId: json['producer_id'] as String,
  );
}

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'producer_id': instance.producerId,
};
