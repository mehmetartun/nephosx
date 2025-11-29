import 'package:json_annotation/json_annotation.dart';

part 'datacenter.g.dart';

enum DatacenterTier {
  tier1("Tier 1", "Uptime > 99.99%", 1),
  tier2("Tier 2", "Uptime > 99.90%", 2),
  tier3("Tier 3", "Uptime > 99.00%", 3),
  tier4("Tier 4", "Uptime > 95.00%", 4);

  final String title;
  final String description;
  final int rank;

  const DatacenterTier(this.title, this.description, this.rank);
}

@JsonSerializable(explicitToJson: true)
class Datacenter {
  final String id;
  final String name;
  @JsonKey(name: "company_id")
  final String companyId;
  final String country;
  final String region;
  final DatacenterTier tier;

  Datacenter({
    required this.id,
    required this.name,
    required this.companyId,
    required this.tier,
    required this.country,
    required this.region,
  });

  Datacenter copyWith({
    String? id,
    String? name,
    String? companyId,
    DatacenterTier? tier,
    String? country,
    String? region,
  }) {
    return Datacenter(
      id: id ?? this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      tier: tier ?? this.tier,
      country: country ?? this.country,
      region: region ?? this.region,
    );
  }

  factory Datacenter.fromJson(Map<String, dynamic> json) =>
      _$DatacenterFromJson(json);

  Map<String, dynamic> toJson() => _$DatacenterToJson(this);
}
