import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';

/*
Profile Repository
*/

abstract class ProfileRepository {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser updatedProfile);
  Future<void> toggleFollow(String currentUid, String targetUid);
}
