import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';

class ProfileUserFields {
  static const String uid = 'uid';
  static const String email = 'email';
  static const String name = 'name';
  static const String searchableName = 'searchableName';
  static const String bio = 'bio';
  static const String profileImageUrl = 'profileImageUrl';
  static const String followers = 'followers';
  static const String following = 'following';
  static const String isPrivate = 'isPrivate';
}

class ProfileUserModel extends AppUserEntity {
  final String bio;
  final String profileImageUrl;
  final bool isPrivate;
  final List<String> followers;
  final List<String> following;

  ProfileUserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.searchableName,
    required this.bio,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
    this.isPrivate = false,
  });

  ProfileUserModel copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    return ProfileUserModel(
      uid: uid,
      email: email,
      name: name,
      searchableName: searchableName,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      followers: newFollowers ?? followers,
      following: newFollowing ?? following,
    );
  }

  ProfileUserEntity copyWithFull({
    String? uid,
    String? bio,
    String? profileImageUrl,
    bool? isPrivate,
    List<String>? followers,
    List<String>? following,
    String? email,
    String? name,
    String? searchableName,
  }) {
    return ProfileUserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      searchableName: searchableName ?? this.searchableName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPrivate: isPrivate ?? this.isPrivate,
      followers: followers ?? List.from(this.followers),
      following: following ?? List.from(this.following),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ProfileUserFields.uid: uid,
      ProfileUserFields.email: email,
      ProfileUserFields.name: name,
      ProfileUserFields.bio: bio,
      ProfileUserFields.searchableName: searchableName,
      ProfileUserFields.profileImageUrl: profileImageUrl,
      ProfileUserFields.followers: followers,
      ProfileUserFields.following: following,
    };
  }

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      uid: json[ProfileUserFields.uid],
      email: json[ProfileUserFields.email],
      name: json[ProfileUserFields.name] ?? '',
      bio: json[ProfileUserFields.bio] ?? '',
      searchableName: json[ProfileUserFields.searchableName] ?? '',
      profileImageUrl: json[ProfileUserFields.profileImageUrl] ?? '',
      followers: List<String>.from(json[ProfileUserFields.followers] ?? []),
      following: List<String>.from(json[ProfileUserFields.following] ?? []),
    );
  }

  // Method to map ProfileUserModel to a domain entity
  ProfileUserEntity toEntity() {
    return ProfileUserEntity(
      uid: uid,
      email: email,
      name: name,
      bio: bio,
      searchableName: searchableName,
      profileImageUrl: profileImageUrl,
      followers: followers,
      following: following,
    );
  }

  // Method to create ProfileUserModel from a domain entity
  factory ProfileUserModel.fromEntity(ProfileUserEntity entity) {
    return ProfileUserModel(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      bio: entity.bio,
      searchableName: entity.searchableName,
      profileImageUrl: entity.profileImageUrl,
      followers: entity.followers,
      following: entity.following,
    );
  }

  static ProfileUserModel getGuestUser() {
    return ProfileUserModel(
      uid: '',
      email: '',
      name: '',
      searchableName: '',
      bio: '',
      profileImageUrl: '',
      followers: [],
      following: [],
      isPrivate: false,
    );
  }

  static ProfileUserEntity getGuestUserAsEntity() {
    return ProfileUserEntity(
      uid: '',
      email: '',
      name: '',
      searchableName: '',
      bio: '',
      profileImageUrl: '',
      followers: [],
      following: [],
      isPrivate: false,
    );
  }
}
