import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';

/// Generated file
/// cmd-> flutter packages pub run build_runner build
part 'app_user_model.g.dart';

// Data layer class
@JsonSerializable()
class AppUserModel {
  final String uid;
  final String email;
  final String name;
  final String searchableName;

  AppUserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.searchableName,
  });

  @override
  String toString() {
    return toJson().toString();
  }

  /// Creates a `AppUserModel` instance from a JSON map.
  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      _$AppUserModelFromJson(json);

  /// Converts the `AppUserModel` instance into a JSON map.
  Map<String, dynamic> toJson() => _$AppUserModelToJson(this);

  /// Converts `AppUserModel` to domain entity.
  AppUserEntity toEntity() {
    return AppUserEntity(
      uid: uid,
      email: email,
      name: name,
      searchableName: searchableName,
    );
  }

  /// Creates a `AppUserModel` from domain entity.
  factory AppUserModel.fromEntity(AppUserEntity entity) {
    return AppUserModel(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      searchableName: entity.searchableName,
    );
  }

  // Create AppUser from JSON string
  factory AppUserModel.fromJsonString(String jsonString) {
    return AppUserModel.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }

  String toJsonString() => jsonEncode(toJson());
}
