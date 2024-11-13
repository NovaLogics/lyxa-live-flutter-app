import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/helper/logger.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  /// Logs in the user with email and password
  /// ->
  @override
  Future<AppUser?> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      // Sign in user
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetch user document from Firestore
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
          .doc(userCredential.user!.uid)
          .get();

      // Create user object
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc.get(AppUserFields.name),
      );

      return user;
    } catch (error) {
      final errorMessage = "${AppStrings.loginFailedError} ${error.toString()}";
      Logger.logError(errorMessage);
      throw Exception(errorMessage);
    }
  }

  /// Registers a new user with name, email, and password
  /// ->
  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Sign up user
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create user object
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // Save user data in firestore
      await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } catch (error) {
      final errorMessage =
          "${AppStrings.registrationFailedError} ${error.toString()}";
      Logger.logError(errorMessage);
      throw Exception(errorMessage);
    }
  }

  /// Retrieves the current logged-in user
  /// ->
  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) return null;

    // Fetch user document from Firestore
    DocumentSnapshot userDoc = await firebaseFirestore
        .collection(FIRESTORE_COLLECTION_USERS)
        .doc(firebaseUser.uid)
        .get();

    // Check if user document exists
    if (!userDoc.exists) return null;

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: userDoc.get(AppUserFields.name),
    );
  }

  /// Logs out the current user
  /// ->
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
