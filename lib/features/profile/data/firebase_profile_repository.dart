import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/constants/constants.dart';
import 'package:lyxa_live/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/features/profile/domain/repositories/profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // Get user document from Firestore
      final userDoc = await firebaseFirestore
          .collection(FIRESTORE_COLLECTION_USERS)
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          // Fetch followes & following
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: followers,
            following: following,
          );
        }
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
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
  Future<void> toggleFollow(String currentUid, String targetUid) async {
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
