import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

/// Defines Authentication Operations For The App
/// ->
abstract class AuthRepository {
  Future<Result<AppUser>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<AppUser>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<AppUser?>> getCurrentUser();

  Future<void> logOut();

  Future<Result<AppUser>> getSavedUser({
    required String key,
  });

  Future<void> saveUserToLocalStorage({
    required AppUser user,
    required String key,
  });
}
