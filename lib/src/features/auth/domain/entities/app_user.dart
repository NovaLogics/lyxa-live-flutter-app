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
  // Only for local validations
  final String? password;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.password,
  });

  // Creates an `AppUser` instance from a JSON map.
  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  // Converts the `AppUser` instance into a JSON map.
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  // Returns a string representation of the `AppUser` instance.
  @override
  String toString() {
    return toJson().toString();
  }
}
