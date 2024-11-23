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
class AppUser {
  final String uid;
  final String email;
  final String name;
  final String searchableName;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.searchableName,
  });

  // Creates an `AppUser` instance from a JSON map.
  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  // Converts the `AppUser` instance into a JSON map.
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  // Convert AppUser to JSON string
  String toJsonString() => jsonEncode(toJson());

  // Create AppUser from JSON string
  factory AppUser.fromJsonString(String jsonString) {
    return AppUser.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  static createWith({String uid = '', String email = '', String name = ''}) {
    return AppUser(
      uid: uid,
      email: email,
      name: name,
      searchableName: name.toLowerCase(),
    );
  }

  // Returns a string representation of the `AppUser` instance.
  @override
  String toString() {
    return toJson().toString();
  }
}
