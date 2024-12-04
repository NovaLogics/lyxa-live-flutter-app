import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/home/domain/repositories/home_repository.dart';
import 'package:lyxa_live/src/features/post/data/models/post_model.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

class HomeRepositoryImpl implements HomeRepository {
  final CollectionReference _postsCollectionRef =
      FirebaseFirestore.instance.collection(firebasePostsCollectionPath);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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

  @override
  Future<Result<ProfileUserEntity>> getCurrentAppUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) throw Exception(ErrorMsgs.userDataNotFound);

      final userDocument = await _firebaseFirestore
          .collection(firebaseUsersCollectionPath)
          .doc(firebaseUser.uid)
          .get();

      if (!userDocument.exists || userDocument.data() == null) {
        throw Exception(ErrorMsgs.cannotFetchProfileError);
      }

      final profileUser = ProfileUserEntity.fromJson(
          userDocument.data() as Map<String, dynamic>);

      return Result.success(
        data: profileUser,
      );
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  // HELPER FUNCTIONS ▼

  Future<PostEntity> _getPostById(String postId) async {
    final postDoc = await _postsCollectionRef.doc(postId).get();

    if (!postDoc.exists) {
      throw Exception(ErrorMsgs.cannotFetchPostError);
    }

    return _postEntityFromSnapshot(postDoc.data());
  }

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
