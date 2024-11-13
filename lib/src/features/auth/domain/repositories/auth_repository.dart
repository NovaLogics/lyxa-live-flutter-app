import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';

/// Defines authentication operations for the app
/// ->
abstract class AuthRepository {
  Future<AppUser?> loginWithEmailPassword(String email, String password);

  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password);

  Future<void> logout();

  Future<AppUser?> getCurrentUser();
}
