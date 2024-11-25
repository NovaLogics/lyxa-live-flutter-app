import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/search/domain/search_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

class FirebaseSearchRepository implements SearchRepository {
  @override
  Future<Result<List<ProfileUser?>>> searchUsers(String query) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection(FIRESTORE_COLLECTION_USERS)
          .where(ProfileUserFields.searchableName,
              isGreaterThanOrEqualTo: query)
          .where(ProfileUserFields.searchableName,
              isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return result.docs
          .map((doc) => ProfileUser.fromJson(doc.data()))
          .toList();
    } catch (error) {
      throw Exception('Error seaching users: ${error.toString()}');
    }
  }
}
