import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<Result<ProfileUser?>> getUserProfileById({
    required String userId,
  }) async {
    try {
      final userDocument = await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
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
  Future<Result<void>> updateProfile(ProfileUser updatedProfile) async {
    try {
      // Convert update profile to json to store in Firestore
      await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
          .doc(updatedProfile.uid)
          .update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl,
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<Result<void>> toggleFollow(String currentUid, String targetUid) async {
    try {
      // Get user document from Firestore
      final currentUserDoc = await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
          .doc(currentUid)
          .get();

      final targetUserDoc = await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
          .doc(targetUid)
          .get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
              List<String>.from(currentUserData['following'] ?? []);

          // Check if the current user is already following the target user

          if (currentFollowing.contains(targetUid)) {
            // Unfollow
            await firebaseFirestore
                .collection(FIRESTORE_COLLECTION_USERS)
                .doc(currentUid)
                .update({
              'following': FieldValue.arrayRemove([targetUid])
            });

            await firebaseFirestore
                .collection(FIRESTORE_COLLECTION_USERS)
                .doc(targetUid)
                .update({
              'followers': FieldValue.arrayRemove([currentUid])
            });
          } else {
            // Follow
            await firebaseFirestore
                .collection(FIRESTORE_COLLECTION_USERS)
                .doc(currentUid)
                .update({
              'following': FieldValue.arrayUnion([targetUid])
            });

            await firebaseFirestore
                .collection(FIRESTORE_COLLECTION_USERS)
                .doc(targetUid)
                .update({
              'followers': FieldValue.arrayUnion([currentUid])
            });
          }
        }
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
