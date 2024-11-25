import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';

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

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;

  final bool isPrivate;

  final List<String> followers;
  final List<String> following;

  ProfileUser({
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

  // Update profile user
  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    return ProfileUser(
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

  static ProfileUser getDefaultGuestUser() {
    return ProfileUser(
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

  //Convert ProfileUser -> json
  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'searchableName': searchableName,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
    };
  }

  //Convert json -> ProfileUser
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      searchableName: json['searchableName'],
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }
}
