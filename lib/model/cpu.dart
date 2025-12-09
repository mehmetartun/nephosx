import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/model/producer.dart';

part 'cpu.g.dart';

@JsonSerializable(explicitToJson: true)
class Cpu {
  final String id;
  final String name;
  @JsonKey(name: "producer_id")
  final String producerId;

  Cpu({required this.id, required this.name, required this.producerId});

  factory Cpu.fromJson(Map<String, dynamic> json) => _$CpuFromJson(json);

  Map<String, dynamic> toJson() => _$CpuToJson(this);
}
