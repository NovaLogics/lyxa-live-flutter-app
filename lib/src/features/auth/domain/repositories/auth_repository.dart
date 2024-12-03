import 'package:lyxa_live/src/features/auth/data/models/app_user_model.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

/// Defines Authentication Operations For The App
/// ->
abstract class AuthRepository {
  Future<Result<AppUserModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<AppUserModel>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<AppUserModel?>> getCurrentUser();

  Future<void> logOut();

  Future<Result<bool>> updateProfileImageUrl({
    required String userId,
    required String profileImageUrl,
  });

  Future<Result<AppUserEntity>> getSavedUser({
    required String storageKey,
  });

  Future<void> saveUserToLocalStorage({
    required String storageKey,
    required AppUserEntity user,
  });
}
