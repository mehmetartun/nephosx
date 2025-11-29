// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import '../services/conversions.dart';
import '../services/mock.dart';
import 'company.dart';

class User {
  String? _firstName;
  String? _lastName;
  String? _displayName;
  String? _email;
  String? _photoUrl;
  String? _photoBase64;
  String? _companyId;
  String _uid;
  Company? _company;

  User._internal(
    this._firstName,
    this._lastName,
    this._displayName,
    this._email,
    this._photoUrl,
    this._photoBase64,
    this._uid,
    this._companyId,
  );

  set firstName(String value) {
    _firstName = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  set displayName(String value) {
    _displayName = value;
  }

  set email(String value) {
    _email = value;
  }

  set photoUrl(String value) {
    _photoUrl = value;
  }

  set photoBase64(String value) {
    _photoBase64 = value;
  }

  set companyId(String value) {
    _companyId = value;
  }

  set company(Company value) {
    _company = value;
  }

  String get firstName => _firstName ?? '';
  String get lastName => _lastName ?? '';
  String get displayName => _displayName ?? '';
  String get email => _email ?? '';
  String get photoUrl => _photoUrl ?? '';
  String get photoBase64 => _photoBase64 ?? '';
  String get uid => _uid;
  String? get companyId => _companyId;
  Company? get company => _company;

  String get initials => Conversions.getInitials(_displayName);

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
  }) {
    return User._internal(
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      displayName ?? this.displayName,
      email ?? this.email,
      photoUrl ?? this.photoUrl,
      photoBase64 ?? this.photoBase64,
      uid ?? this.uid,
      companyId ?? this.companyId,
    ).._company = company ?? this.company;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'display_name': displayName,
      'email': email,
      'photo_url': photoUrl,
      'photo_base64': photoBase64,
      'uid': uid,
      'company_id': companyId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map['uid'] == null) {
      throw Exception('UID is required to create a User');
    }
    return User._internal(
      map['first_name'] == null ? null : map['first_name'] as String,
      map['last_name'] == null ? null : map['last_name'] as String,
      map['display_name'] == null ? null : map['display_name'] as String,
      map['email'] == null ? null : map['email'] as String,
      map['photo_url'] == null ? null : map['photo_url'] as String,
      map['photo_base64'] == null ? null : map['photo_base64'] as String,
      map['uid'] as String,
      map['company_id'] == null ? null : map['company_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  static User createMockUser() {
    String fN = Mock.firstName();
    String lN = Mock.lastName();

    return User._internal(
      fN,
      lN,
      "$fN $lN",
      "$fN@$lN.com",
      Mock.imageUrl(),
      null, // TODO: Modify Mock to give a base64 image
      Mock.uid(),
      Mock.uid(),
    );
  }

  @override
  String toString() {
    return 'User(fN: $firstName, lN: $lastName, dN: $displayName,  uid: $uid\n'
        'email: $email\n photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.displayName == displayName &&
        other.email == email &&
        other.photoUrl == photoUrl &&
        other.uid == uid &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        photoUrl.hashCode ^
        uid.hashCode ^
        companyId.hashCode;
  }

  Company? getCompany(List<Company> companies) {
    return companies.firstWhereOrNull((company) => company.id == companyId);
  }
}
