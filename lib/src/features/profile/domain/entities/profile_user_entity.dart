import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';

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
}
