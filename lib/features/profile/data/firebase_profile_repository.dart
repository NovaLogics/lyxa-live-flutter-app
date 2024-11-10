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
      final userDoc =
          await firebaseFirestore.collection(dbPathUsers).doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio']  ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
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
          .collection(dbPathUsers)
          .doc(updatedProfile.uid)
          .update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl,
      });
    } catch (error) {
      throw Exception(error);
    }
  }
}
