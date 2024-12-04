import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/features/search/domain/repositories/search_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

class SearchRepositoryImpl implements SearchRepository {
  final String searchableSuffix = '\uf8ff';

  @override
  Future<Result<List<ProfileUserEntity?>>> searchUsers(String query) async {
    try {
      final searchResult = await FirebaseFirestore.instance
          .collection(firebaseUsersCollectionPath)
          .where(ProfileUserFields.searchableName,
              isGreaterThanOrEqualTo: query)
          .where(ProfileUserFields.searchableName,
              isLessThanOrEqualTo: '$query$searchableSuffix')
          .get();

      final userList = searchResult.docs
          .map((document) => ProfileUserEntity.fromJson(document.data()))
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
