import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

///Generated file
///cmd-> flutter packages pub run build_runner build
part 'app_user.g.dart';

class AppUserFields {
  static const uid = 'uid';
  static const email = 'email';
  static const name = 'name';
}

@JsonSerializable()
class AppUserEntity {
  final String uid;
  final String email;
  final String name;
  final String searchableName;

  AppUserEntity({
    required this.uid,
    required this.email,
    required this.name,
    required this.searchableName,
  });



    @override
  String toString() {
    return 'AppUserEntity(uid: $uid, email: $email, name: $name)';
  }

  // Creates an `AppUser` instance from a JSON map.
  factory AppUserEntity.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  // Converts the `AppUser` instance into a JSON map.
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  // Create AppUser from JSON string
  factory AppUserEntity.fromJsonString(String jsonString) {
    return AppUserEntity.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>);
  }

  String toJsonString() => jsonEncode(toJson());

  static createWith({
    String uid = AppUserConstants.defaultValue,
    String email = AppUserConstants.defaultValue,
    String name = AppUserConstants.defaultValue,
  }) {
    return AppUserEntity(
      uid: uid,
      email: email,
      name: name,
      searchableName: name.toLowerCase(),
    );
  }

  static getDefaultGuestUser() {
    return AppUserEntity(
      uid: AppUserConstants.defaultValue,
      email: AppUserConstants.defaultEmail,
      name: AppUserConstants.defaultName,
      searchableName: AppUserConstants.defaultSearchableName,
    );
  }
}

class AppUserConstants {
  static const String defaultValue = '';
  static const String defaultEmail = 'Guest@lyxa.com';
  static const String defaultName = 'Guest';
  static const String defaultSearchableName = 'guest';
}
