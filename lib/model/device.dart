import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/model/producer.dart';

part 'device.g.dart';

@JsonSerializable(explicitToJson: true)
class Device {
  final String id;
  final String name;
  @JsonKey(name: "producer_id")
  final String producerId;
  final String architecture;

  Device({
    required this.id,
    required this.name,
    required this.producerId,
    required this.architecture,
  });

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
