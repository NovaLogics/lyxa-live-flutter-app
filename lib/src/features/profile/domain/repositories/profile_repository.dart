import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class ProfileRepository {
  Future<Result<ProfileUser?>> fetchUserProfile({
    required String userId,
  });

  Future<Result<void>> updateProfile({
    required ProfileUser updatedProfile,
  });

  Future<Result<void>> toggleFollow({
    required String appUserId,
    required String targetUserId,
  });
}
