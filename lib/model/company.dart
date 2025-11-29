import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/services/mock.dart';

part 'company.g.dart';

@JsonSerializable(explicitToJson: true)
class Company {
  final String id;
  final String name;
  final String country;
  final String city;

  Company({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
  });

  static Company createMockCompany() {
    return Company(
      id: Mock.uid(),
      name: Mock.firstName(),
      country: Mock.firstName(),
      city: Mock.firstName(),
    );
  }

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
