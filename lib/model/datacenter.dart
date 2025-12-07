import 'package:json_annotation/json_annotation.dart';

import 'address.dart';

part 'datacenter.g.dart';

enum DatacenterTier {
  tier1("Tier 1", "Uptime > 99.99%", 1, "Tier I"),
  tier2("Tier 2", "Uptime > 99.90%", 2, "Tier II"),
  tier3("Tier 3", "Uptime > 99.00%", 3, "Tier III"),
  tier4("Tier 4", "Uptime > 95.00%", 4, "Tier IV");

  final String title;
  final String roman;
  final String description;
  final int rank;

  const DatacenterTier(this.title, this.description, this.rank, this.roman);
}

@JsonSerializable(explicitToJson: true)
class Datacenter {
  final String id;
  final String name;
  @JsonKey(name: "company_id")
  final String companyId;
  final Address address;
  final DatacenterTier tier;
  final bool iso27001;

  Datacenter({
    required this.id,
    required this.name,
    required this.companyId,
    required this.address,
    required this.tier,
    this.iso27001 = false,
    // required this.country,
    // required this.region,
  });

  Datacenter copyWith({
    String? id,
    String? name,
    String? companyId,
    DatacenterTier? tier,
    // String? country,
    // String? region,
    Address? address,
    bool? iso27001,
  }) {
    return Datacenter(
      id: id ?? this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      tier: tier ?? this.tier,
      // country: country ?? this.country,
      // region: region ?? this.region,
      address: address ?? this.address,
      iso27001: iso27001 ?? this.iso27001,
    );
  }

  factory Datacenter.fromJson(Map<String, dynamic> json) =>
      _$DatacenterFromJson(json);

  Map<String, dynamic> toJson() => _$DatacenterToJson(this);

  @override
  bool operator ==(Object other) {
    // 1. Check for identical instances (same memory address)
    if (identical(this, other)) return true;

    // 2. Check if 'other' is of the same runtime type
    if (other.runtimeType != runtimeType) return false;

    // 3. Compare relevant properties for value equality
    return other is Datacenter && id == other.id;
  }
}
