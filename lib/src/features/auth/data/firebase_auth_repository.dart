import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';

import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/firebase_error_util.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final HiveHelper hiveHelper = getIt<HiveHelper>();
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
        searchableName:
            userDoc.get(AppUserFields.name).toString().toLowerCase(),
      );

      return user;
    } on FirebaseAuthException catch (error) {
      final errorData = FirebaseErrorUtil.getMessage(error.code);
      Logger.logError(error.code);
      Logger.logError(errorData);
      throw Exception(errorData);
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
        searchableName: name.toLowerCase(),
      );

      // Save user data in firestore
      await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } on FirebaseAuthException catch (error) {
      final errorData = FirebaseErrorUtil.getMessage(error.code);
      Logger.logError(error.code);
      Logger.logError(errorData);
      throw Exception(errorData);
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
      searchableName: userDoc.get(AppUserFields.name).toString().toLowerCase(),
    );
  }

  /// Logs out the current user
  /// ->
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getSavedUser({String key = HiveKeys.loginDataKey}) async {
    final String loginData = hiveHelper.getValue<String>(key, '');
    if (loginData.isNotEmpty) {
      try {
        return AppUser.fromJsonString(loginData);
      } catch (e) {
        Logger.logError(e.toString());
      }
    }
    return null;
  }

  @override
  Future<void> saveUser(AppUser user,
      {String key = HiveKeys.loginDataKey}) async {
    await hiveHelper.save(key, user.toJsonString());
  }
}
