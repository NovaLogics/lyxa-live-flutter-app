import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<Result<ProfileUser?>> getUserProfileById({
    required String userId,
  }) async {
    try {
      final userDocument = await firebaseFirestore
          .collection(firebaseUsersCollectionPath)
          .doc(userId)
          .get();

      if (!userDocument.exists || userDocument.data() == null) {
        throw Exception(ErrorMsgs.cannotFetchProfileError);
      }

      final profileUser =
          ProfileUser.fromJson(userDocument.data() as Map<String, dynamic>);

      return Result.success(
        data: profileUser,
      );
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> updateProfile({
    required ProfileUser updatedProfile,
  }) async {
    try {
      await firebaseFirestore
          .collection(firebaseUsersCollectionPath)
          .doc(updatedProfile.uid)
          .update({
        ProfileUserFields.bio: updatedProfile.bio,
        ProfileUserFields.profileImageUrl: updatedProfile.profileImageUrl,
      });
      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> toggleFollow({
    required String appUserId,
    required String targetUserId,
  }) async {
    try {
      final appUserDocumentRef = firebaseFirestore
          .collection(firebaseUsersCollectionPath)
          .doc(appUserId);

      final targetUserDocumentRef = firebaseFirestore
          .collection(firebaseUsersCollectionPath)
          .doc(targetUserId);

      final appUserDocument = await appUserDocumentRef.get();

      final targetUserDocument = await targetUserDocumentRef.get();

      if (!appUserDocument.exists ||
          !targetUserDocument.exists ||
          appUserDocument.data() == null ||
          targetUserDocument.data() == null) {
        throw Exception(ErrorMsgs.cannotFetchProfileError);
      }

      final List<String> currentFollowingUserList = List<String>.from(
          appUserDocument.data()?[ProfileUserFields.following] ?? []);

      // UNFOLLOW
      if (currentFollowingUserList.contains(targetUserId)) {
        await appUserDocumentRef.update({
          ProfileUserFields.following: FieldValue.arrayRemove([targetUserId])
        });

        await targetUserDocumentRef.update({
          ProfileUserFields.followers: FieldValue.arrayRemove([appUserId])
        });
      }
      // FOLLOW
      else {
        await appUserDocumentRef.update({
          ProfileUserFields.following: FieldValue.arrayUnion([targetUserId])
        });

        await targetUserDocumentRef.update({
          ProfileUserFields.followers: FieldValue.arrayUnion([appUserId])
        });
      }
      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }
}
