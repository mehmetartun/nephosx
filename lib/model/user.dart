// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '../services/mock.dart';
import 'address.dart';
import 'company.dart';
import 'conversions.dart';
import 'enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'display_name')
  final String? displayName;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'email_verified')
  final bool emailVerified;

  @JsonKey(name: 'created_at', includeToJson: false, includeFromJson: true)
  @TimestampConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'last_login_at', includeToJson: false, includeFromJson: true)
  @TimestampConverter()
  final DateTime? lastLoginAt;

  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  @JsonKey(name: 'photo_base64')
  final String? photoBase64;

  @JsonKey(name: 'company_id')
  final String? companyId;

  @JsonKey(name: 'uid')
  final String uid;

  @JsonKey(name: 'company', includeToJson: false, includeFromJson: true)
  final Company? company;

  @JsonKey(name: 'type')
  final UserType? type;

  @JsonKey(name: 'address', includeToJson: true, includeFromJson: true)
  final Address? address;

  @JsonKey(name: 'is_anonymous')
  final bool isAnonymous;

  User({
    this.firstName,
    this.lastName,
    this.displayName,
    this.email,
    this.photoUrl,
    this.photoBase64,
    this.companyId,
    required this.uid,
    this.company,
    this.type,
    this.address,
    this.emailVerified = false,
    this.createdAt,
    this.lastLoginAt,
    this.isAnonymous = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get initials => Conversions.getInitials(displayName);

  User copyWith({
    String? firstName,
    String? lastName,
    String? displayName,
    String? email,
    String? photoUrl,
    String? photoBase64,
    String? uid,
    String? companyId,
    Company? company,
    UserType? type,
    Address? address,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isAnonymous,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      photoBase64: photoBase64 ?? this.photoBase64,
      uid: uid ?? this.uid,
      companyId: companyId ?? this.companyId,
      company: company ?? this.company,
      type: type ?? this.type,
      address: address ?? this.address,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  static User createMockUser() {
    String fN = Mock.firstName();
    String lN = Mock.lastName();

    return User(
      firstName: fN,
      lastName: lN,
      displayName: "$fN $lN",
      email: "$fN@$lN.com",
      photoUrl: Mock.imageUrl(),
      photoBase64: null, // TODO: Modify Mock to give a base64 image
      uid: Mock.uid(),
      companyId: Mock.uid(),
      company: Company.createMockCompany(),
      type: UserType.public,
    );
  }

  bool get canSeeMarketplace => true;

  bool get canSeeCompanies => type != UserType.anonymous;
  bool get canSeeDatacenters =>
      (type != UserType.anonymous && type != UserType.public);
  bool get canSeeGpuClusters =>
      (type != UserType.anonymous && type != UserType.public);
  bool get canSeeSettings => (type != UserType.anonymous);
  bool get canSeeUsers =>
      (type != UserType.anonymous && type != UserType.public);

  bool get canSeeTransactions =>
      (type != UserType.anonymous && type != UserType.public);
  bool get canSeePrices =>
      (type != UserType.anonymous && type != UserType.public);

  bool get canSeeAdmin => type == UserType.admin;

  @override
  String toString() {
    return 'User(fN: $firstName, lN: $lastName, dN: $displayName,  uid: $uid\n'
        'email: $email\n photoUrl: $photoUrl)';
  }

  Company? getCompany(List<Company> companies) {
    return companies.firstWhereOrNull((company) => company.id == companyId);
  }
}
