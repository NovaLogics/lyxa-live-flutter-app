import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

/// Defines Authentication Operations For The App
/// ->
abstract class AuthRepository {
  Future<Result<AppUserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<AppUserEntity>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<AppUserEntity?>> getCurrentUser();

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
