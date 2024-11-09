import 'package:lyxa_live/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository{
  @override
  Future<AppUser?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password) {
    // TODO: implement registerWithEmailPassword
    throw UnimplementedError();
  }

}