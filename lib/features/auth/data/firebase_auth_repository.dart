import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyxa_live/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      //Attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
      );
    } catch (error) {
      throw Exception('Login Failed: ${error.toString()}');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      //Attempt sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );
    } catch (error) {
      throw Exception('Login Failed: ${error.toString()}');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        name: '',
      );
  }

  @override
  Future<void> logout() async {
    firebaseAuth.signOut();
  }
}
