import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/home/domain/repositories/home_repository.dart';
import 'package:lyxa_live/src/features/post/data/models/post_model.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

class HomeRepositoryImpl implements HomeRepository {
  final CollectionReference _postsCollectionRef =
      FirebaseFirestore.instance.collection(firebasePostsCollectionPath);

  @override
  Future<Result<List<PostEntity>>> getAllPosts() async {
    try {
      final postSnapshot = await _postsCollectionRef
          .orderBy(PostFields.timestamp, descending: true)
          .get();

      final List<PostEntity>? allPosts = _mapSnapshotToPosts(postSnapshot);

      return Result.success(
        data: allPosts ?? List.empty(),
      );
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  // HELPER FUNCTIONS ▼
  List<PostEntity>? _mapSnapshotToPosts(QuerySnapshot postSnapshot) {
    return postSnapshot.docs
        .map((document) => _postEntityFromSnapshot(document.data()))
        .toList();
  }

  PostEntity _postEntityFromSnapshot(Object? jsonData) {
    final postModel = PostModel.fromJson(jsonData as Map<String, dynamic>);
    return postModel.toEntity();
  }
}
