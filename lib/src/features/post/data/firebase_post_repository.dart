import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

class FirebasePostRepository implements PostRepository {
  final CollectionReference _postsCollectionRef =
      FirebaseFirestore.instance.collection(FIRESTORE_COLLECTION_POSTS);

  @override
  Future<Result<List<Post>>> getAllPosts() async {
    try {
      final postSnapshot = await _postsCollectionRef
          .orderBy(PostFields.timestamp, descending: true)
          .get();

      final List<Post>? allPosts = _mapSnapshotToPosts(postSnapshot);

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
  Future<Result<List<Post>>> getPostsForUser({
    required String userId,
  }) async {
    try {
      final postSnapshot = await _postsCollectionRef
          .where(PostFields.userId, isEqualTo: userId)
          .get();

      final List<Post>? userPosts = _mapSnapshotToPosts(postSnapshot);

      return Result.success(
        data: userPosts ?? List.empty(),
      );
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> addPost({
    required Post newPost,
  }) async {
    try {
      await _postsCollectionRef.doc(newPost.id).set(newPost.toJson());

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> removePost({
    required String postId,
  }) async {
    try {
      await _postsCollectionRef.doc(postId).delete();

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> togglePostLike({
    required String postId,
    required String userId,
  }) async {
    try {
      final post = await _getPostById(postId);

      final isAlreadyLiked = post.likes.contains(userId);

      if (isAlreadyLiked) {
        post.likes.remove(userId);
      } else {
        post.likes.add(userId);
      }

      await _postsCollectionRef
          .doc(postId)
          .update({PostFields.likes: post.likes});

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> addCommentToPost({
    required String postId,
    required Comment comment,
  }) async {
    try {
      final post = await _getPostById(postId);

      post.comments.add(comment);

      final updatedComments =
          post.comments.map((comment) => comment.toJson()).toList();

      await _postsCollectionRef
          .doc(postId)
          .update({PostFields.comments: updatedComments});

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> removeCommentFromPost({
    required String postId,
    required String commentId,
  }) async {
    try {
      final post = await _getPostById(postId);

      post.comments.removeWhere((comment) => comment.id == commentId);

      final updatedComments =
          post.comments.map((comment) => comment.toJson()).toList();

      await _postsCollectionRef
          .doc(postId)
          .update({PostFields.comments: updatedComments});

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  // HELPER FUNCTIONS ▼

  Future<Post> _getPostById(String postId) async {
    final postDoc = await _postsCollectionRef.doc(postId).get();

    if (!postDoc.exists) {
      throw Exception(ErrorMsgs.cannotFetchPostError);
    }
    return Post.fromJson(postDoc.data() as Map<String, dynamic>);
  }

  List<Post>? _mapSnapshotToPosts(QuerySnapshot postSnapshot) {
    return postSnapshot.docs
        .map((document) =>
            Post.fromJson(document.data() as Map<String, dynamic>))
        .toList();
  }
}
