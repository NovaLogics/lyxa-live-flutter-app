import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class ProfileRepository {
  Future<Result<ProfileUserEntity?>> getUserProfileById({
    required String userId,
  });

  Future<Result<void>> updateProfile({
    required ProfileUserEntity updatedProfile,
  });

  Future<Result<void>> toggleFollow({
    required String appUserId,
    required String targetUserId,
  });
}
