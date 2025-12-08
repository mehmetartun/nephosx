import 'package:json_annotation/json_annotation.dart';

part 'producer.g.dart';

@JsonSerializable(explicitToJson: true)
class Producer {
  final String id;
  final String name;

  Producer({required this.id, required this.name});

  factory Producer.fromJson(Map<String, dynamic> json) =>
      _$ProducerFromJson(json);

  Map<String, dynamic> toJson() => _$ProducerToJson(this);
}
