import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';

import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/firebase_error_util.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/shared/entities/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/firebase_error_handler.dart';

class FirebaseAuthRepository implements AuthRepository {
  final HiveHelper hiveHelper = getIt<HiveHelper>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  /// Logs in the user with email and password
  /// ->
  @override
  Future<Result<AppUser>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
    
      // Set Firebase language preference
      firebaseAuth.setLanguageCode(AppStrings.languageCodeEnglish);

      // Authenticate the user
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String? userId = userCredential.user?.uid;

      if (userId == null || userId.isEmpty) {
        throw Exception(ErrorMessages.failedToRetrieveUserId);
      }

      // Retrieve user data from Firestore
      final DocumentSnapshot<Map<String, dynamic>> userDocument =
          await firebaseFirestore
              .collection(FIRESTORE_COLLECTION_USERS)
              .doc(userId)
              .get();

      if (!userDocument.exists) {
        throw Exception(ErrorMessages.userDataNotFound);
      }

      final String name = userDocument.data()?[AppUserFields.name] as String? ??
          AppStrings.unknown;
      // Map Firestore document to [AppUser]
      final AppUser user = AppUser(
        uid: userId,
        email: email,
        name: name,
        searchableName: name.toLowerCase(),
      );

      return Result.success(user);
    } on FirebaseAuthException catch (authError) {
      final errorMessage = FirebaseErrorHandler.getMessage(authError.code);
      return Result.errorMessage(errorMessage);
    } catch (error) {
      return Result.error(error);
    }
  }

  /// Registers a new user with name, email, and password
  /// ->
  @override
  Future<AppUser?> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
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
  Future<void> logOut() async {
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
  Future<void> saveUserToLocalStorage({
    required AppUser user,
    String key = HiveKeys.loginDataKey,
  }) async {
    await hiveHelper.save(key, user.toJsonString());
  }
}
