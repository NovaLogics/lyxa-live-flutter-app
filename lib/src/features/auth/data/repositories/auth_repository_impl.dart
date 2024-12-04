import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';

import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/database/hive_storage.dart';
import 'package:lyxa_live/src/features/auth/data/models/app_user_model.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/features/profile/data/models/profile_user_model.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HiveStorage _hiveStorage = getIt<HiveStorage>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection(firebaseUsersCollectionPath);

  @override
  Future<Result<AppUserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _firebaseAuth.setLanguageCode(AppStrings.languageCodeEnglish);

      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final String? userId = userCredential.user?.uid;

      if (userId == null || userId.isEmpty) {
        return Result.error(ErrorMsgs.failedToRetrieveUserId);
      }

      final appUser = await _getUserById(userId);

      _hiveStorage.deleteLoginData();

      return Result.success(
        data: appUser.toEntity(),
      );
    } on FirebaseAuthException catch (authError) {
      return Result.error(FirebaseError(authError));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<AppUserEntity>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final String? userId = userCredential.user?.uid;

      if (userId == null || userId.isEmpty) {
        return Result.error(ErrorMsgs.failedToRetrieveUserId);
      }

      AppUserModel user = AppUserModel(
        uid: userId,
        email: email,
        name: name,
        searchableName: name.toLowerCase(),
      );

      await _userCollectionRef.doc(userId).set(user.toJson());

      _hiveStorage.deleteLoginData();

      return Result.success(
        data: user.toEntity(),
      );
    } on FirebaseAuthException catch (authError) {
      return Result.error(FirebaseError(authError));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<bool>> updateProfileImageUrl({
    required String userId,
    required String profileImageUrl,
  }) async {
    try {
      await _userCollectionRef
          .doc(userId)
          .update({ProfileUserFields.profileImageUrl: profileImageUrl});
      return Result.success(
        data: true,
      );
    } on FirebaseAuthException catch (authError) {
      return Result.error(FirebaseError(authError));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<AppUserEntity?>> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;

      // No user logged in
      if (firebaseUser == null) return Result.success(data: null);

      final appUser = await _getUserById(firebaseUser.uid);

      return Result.success(
        data: appUser.toEntity(),
      );
    } on FirebaseAuthException catch (authError) {
      return Result.error(FirebaseError(authError));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<Result<AppUserEntity>> getSavedUser({
    required String storageKey,
  }) async {
    try {
      final String? userData = _hiveStorage.get<String>(storageKey);

      if (userData == null || userData.isEmpty) {
        return Result.error(ErrorMsgs.userDataNotFound);
      }

      final appUserModel = AppUserModel.fromJsonString(userData);

      return Result.success(
        data: appUserModel.toEntity(),
      );
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<void> saveUserToLocalStorage({
    required AppUserEntity user,
    required String storageKey,
  }) async {
    final userJson = AppUserModel.fromEntity(user).toJsonString();
    await _hiveStorage.save(storageKey, userJson);
  }

  // HELPER FUNCTIONS ▼

  Future<AppUserModel> _getUserById(String userId) async {
    final userDocument = await _userCollectionRef.doc(userId).get();

    if (!userDocument.exists) {
      throw Exception(ErrorMsgs.userDataNotFound);
    }
    return AppUserModel.fromJson(userDocument.data() as Map<String, dynamic>);
  }
}
