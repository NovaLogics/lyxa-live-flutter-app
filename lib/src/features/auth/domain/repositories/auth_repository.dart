import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';

/// Defines Authentication Operations For The App
/// ->
abstract class AuthRepository {
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  );

  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  );

  Future<AppUser?> getCurrentUser();

  Future<void> logOut();

  Future<AppUser?> getSavedUser({
    String key = HiveKeys.loginDataKey,
  });

  Future<void> saveUserToLocalStorage({
    required AppUser user,
    String key = HiveKeys.loginDataKey,
  });
}
