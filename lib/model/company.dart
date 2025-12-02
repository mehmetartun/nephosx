import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/services/mock.dart';

import 'address.dart';
import 'user.dart';

part 'company.g.dart';

@JsonSerializable(explicitToJson: true)
class Company {
  final String id;
  final String name;
  @JsonKey(name: "confirmation_email")
  final String? confirmationEmail;
  // @JsonKey(name: "address_ids", includeFromJson: true, includeToJson: false)
  // final List<String> addressIds;
  @JsonKey(name: "addresses", includeFromJson: true, includeToJson: true)
  final List<Address> addresses;
  @JsonKey(name: "business_tax_id")
  final String? businessTaxId;
  @JsonKey(name: "business_duns_number")
  final String? businessDunsNumber;
  @JsonKey(name: "primary_contact", includeFromJson: true, includeToJson: false)
  final User? primaryContact;
  @JsonKey(name: "primary_contact_id")
  final String? primaryContactId;
  @JsonKey(name: "is_buyer")
  final bool? isBuyer;
  @JsonKey(name: "is_seller")
  final bool? isSeller;

  Company({
    required this.id,
    required this.name,

    this.addresses = const [],
    this.businessTaxId,
    this.primaryContact,
    this.primaryContactId,
    this.isBuyer,
    this.isSeller,
    this.confirmationEmail,
    this.businessDunsNumber,
    // this.addressIds = const [],
  });

  bool get hasAddress {
    return addresses.isNotEmpty;
  }

  bool get isOnBoarded {
    return (primaryContactId != null &&
        addresses.isNotEmpty &&
        businessTaxId != null &&
        isBuyer != null &&
        isSeller != null &&
        confirmationEmail != null);
  }

  String get onBoardingStatus {
    List<String> rets = [];
    if (primaryContactId == null) {
      rets.add("Primary contact not set");
    }
    if (!hasAddress) {
      rets.add("Address not set");
    }
    if (businessTaxId == null) {
      rets.add("Business tax id not set");
    }
    if (isBuyer == null) {
      rets.add("Buyer status not set");
    }
    if (isSeller == null) {
      rets.add("Seller status not set");
    }
    if (confirmationEmail == null) {
      rets.add("Confirmation email not set");
    }
    return rets.join(", ");
  }

  Company copyWith({
    String? id,
    String? name,
    List<Address>? addresses,
    // List<String>? addressIds,
    String? businessTaxId,
    User? primaryContact,
    String? primaryContactId,
    bool? isBuyer,
    bool? isSeller,
    String? confirmationEmail,
    String? businessDunsNumber,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      addresses: addresses ?? this.addresses,
      // addressIds: addressIds ?? this.addressIds,
      businessTaxId: businessTaxId ?? this.businessTaxId,
      primaryContact: primaryContact ?? this.primaryContact,
      primaryContactId: primaryContactId ?? this.primaryContactId,
      isBuyer: isBuyer ?? this.isBuyer,
      isSeller: isSeller ?? this.isSeller,
      confirmationEmail: confirmationEmail ?? this.confirmationEmail,
      businessDunsNumber: businessDunsNumber ?? this.businessDunsNumber,
    );
  }

  static Company createMockCompany() {
    return Company(id: Mock.uid(), name: Mock.firstName());
  }

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
