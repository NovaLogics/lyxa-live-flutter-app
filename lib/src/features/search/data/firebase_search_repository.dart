import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/search/domain/search_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

class FirebaseSearchRepository implements SearchRepository {
  @override
  Future<Result<List<ProfileUser?>>> searchUsers(String query) async {
    try {
      final searchResult = await FirebaseFirestore.instance
          .collection(FIRESTORE_COLLECTION_USERS)
          .where(ProfileUserFields.searchableName,
              isGreaterThanOrEqualTo: query)
          .where(ProfileUserFields.searchableName,
              isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final userList = searchResult.docs
          .map((document) => ProfileUser.fromJson(document.data()))
          .toList();

      return Result.success(
        data: userList,
      );
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }
}
