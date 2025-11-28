// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../services/conversions.dart';
import '../services/mock.dart';

class User {
  String? _firstName;
  String? _lastName;
  String? _displayName;
  String? _email;
  String? _photoUrl;
  String? _photoBase64;
  String _uid;

  User._internal(
    this._firstName,
    this._lastName,
    this._displayName,
    this._email,
    this._photoUrl,
    this._photoBase64,
    this._uid,
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

  String get firstName => _firstName ?? '';
  String get lastName => _lastName ?? '';
  String get displayName => _displayName ?? '';
  String get email => _email ?? '';
  String get photoUrl => _photoUrl ?? '';
  String get photoBase64 => _photoBase64 ?? '';
  String get uid => _uid;

  String get initials => Conversions.getInitials(_displayName);

  User copyWith({
    String? firstName,
    String? lastName,
    String? displayName,
    String? email,
    String? photoUrl,
    String? photoBase64,

    String? uid,
  }) {
    return User._internal(
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      displayName ?? this.displayName,
      email ?? this.email,
      photoUrl ?? this.photoUrl,
      photoBase64 ?? this.photoBase64,
      uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'photoBase64': photoBase64,
      'uid': uid,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map['uid'] == null) {
      throw Exception('UID is required to create a User');
    }
    return User._internal(
      map['firstName'] == null ? null : map['firstName'] as String,
      map['lastName'] == null ? null : map['lastName'] as String,
      map['displayName'] == null ? null : map['displayName'] as String,
      map['email'] == null ? null : map['email'] as String,
      map['photoUrl'] == null ? null : map['photoUrl'] as String,
      map['photoBase64'] == null ? null : map['photoBase64'] as String,
      map['uid'] as String,
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
        other.uid == uid;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        photoUrl.hashCode ^
        uid.hashCode;
  }
}
