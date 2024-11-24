import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';

import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

class FirebaseAuthRepository implements AuthRepository {
  final HiveHelper hiveHelper = getIt<HiveHelper>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  /// (ƒ) :: Login With Email And Password
  ///
  /// Returns a [Result] with the [AppUser] on success or an error on failure
  ///
  /// Parameters:
  /// - [email]: User's email address.
  /// - [password]: User's password.
  @override
  Future<Result<AppUser>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Set Firebase language preference
      firebaseAuth.setLanguageCode(AppStrings.languageCodeEnglish);

      // Authenticate the user
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

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

      return Result.success(
        data: user,
      );
    } on FirebaseAuthException catch (authError) {
      return Result.error(FirebaseError(authError));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  ///  (ƒ) :: Register With Email And Password
  ///
  /// Returns a [Result] with the [AppUser] on success or an error on failure
  ///
  /// Parameters:
  /// - [name]: User's full name.
  /// - [email]: User's email address.
  /// - [password]: User's password.
  @override
  Future<Result<AppUser>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Sign up user
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final String? userId = userCredential.user?.uid;

      if (userId == null || userId.isEmpty) {
        throw Exception(ErrorMessages.failedToRetrieveUserId);
      }

      // Create user object
      AppUser user = AppUser(
        uid: userId,
        email: email,
        name: name,
        searchableName: name.toLowerCase(),
      );

      // Save user data in firestore
      await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
          .doc(user.uid)
          .set(user.toJson());

      return Result.success(
        data: user,
      );
    } on FirebaseAuthException catch (authError) {
      return Result.error(FirebaseError(authError));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  ///  (ƒ) :: Get Current User
  /// ->
  /// Returns [Result.success] with the [AppUser] if found,
  /// or [Result.error] if an error occurs.
  @override
  Future<Result<AppUser?>> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;

      // No user logged in
      if (firebaseUser == null) {
        return Result.success(data: null);
      }

      // Fetch user document from Firestore
      final userDocument = await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
          .doc(firebaseUser.uid)
          .get();

      if (!userDocument.exists) {
        throw Exception(ErrorMessages.userDataNotFound);
      }

      final data = userDocument.data();
      if (data == null ||
          !data.containsKey(AppUserFields.name) ||
          !data.containsKey(AppUserFields.email)) {
        throw Exception(ErrorMessages.userDataNotFound);
      }

      final user = AppUser(
        uid: firebaseUser.uid,
        email: data[AppUserFields.email] as String,
        name: data[AppUserFields.name] as String,
        searchableName: (data[AppUserFields.name] as String).toLowerCase(),
      );

      return Result.success(
        data: user,
      );
    } on FirebaseAuthException catch (authError) {
      return Result.error(FirebaseError(authError));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  ///  (ƒ) :: Logout
  /// ->
  /// Logs out the current user by signing out from Firebase.
  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  /// (ƒ) :: Get Saved User | LocalDB
  /// ->
  /// Returns the [AppUser] if found, or Error if not
  @override
  Future<Result<AppUser>> getSavedUser({
    required String key,
  }) async {
    final String? userData = hiveHelper.get<String>(key);
    if (userData != null && userData.isNotEmpty) {
      try {
        final user = AppUser.fromJsonString(userData);
        return Result.success(
          data: user,
        );
      } catch (error) {
        return Result.error(GenericError(error: error));
      }
    }
    return Result.error(GenericError(message: ErrorMessages.userDataNotFound));
  }

  /// (ƒ) :: Save User To Local Storage | LocalDB
  /// ->
  /// Saves the [AppUser] to local storage with the specified key
  @override
  Future<void> saveUserToLocalStorage({
    required AppUser user,
    String key = HiveKeys.loginDataKey,
  }) async {
    await hiveHelper.save(key, user.toJsonString());
  }
}
