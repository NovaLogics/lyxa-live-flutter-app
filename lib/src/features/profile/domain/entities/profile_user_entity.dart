import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';

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

class ProfileUserEntity extends AppUserEntity {
  final String bio;
  final String profileImageUrl;
  final bool isPrivate;
  final List<String> followers;
  final List<String> following;

  ProfileUserEntity({
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

  ProfileUserEntity copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    return ProfileUserEntity(
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

  factory ProfileUserEntity.fromJson(Map<String, dynamic> json) {
    return ProfileUserEntity(
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

  static ProfileUserEntity getGuestUser() {
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
