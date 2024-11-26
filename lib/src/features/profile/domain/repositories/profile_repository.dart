import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class ProfileRepository {
  Future<Result<ProfileUser>> fetchUserProfile(String uid);
  Future<Result<void>> updateProfile(ProfileUser updatedProfile);
  Future<Result<void>> toggleFollow(String currentUid, String targetUid);
}
