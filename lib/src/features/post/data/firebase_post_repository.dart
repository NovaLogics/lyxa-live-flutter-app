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
  final CollectionReference postsCollectionRef =
      FirebaseFirestore.instance.collection(FIRESTORE_COLLECTION_POSTS);

  @override
  Future<Result<List<Post>>> getAllPosts() async {
    try {
      final postSnapshot =
          await postsCollectionRef.orderBy('timestamp', descending: true).get();

      final List<Post> allPosts = mapSnapshotToPosts(postSnapshot);

      return Result.success(
        data: allPosts,
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
      final postSnapshot =
          await postsCollectionRef.where('userId', isEqualTo: userId).get();

      final List<Post> userPosts = mapSnapshotToPosts(postSnapshot);

      return Result.success(
        data: userPosts,
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
      await postsCollectionRef.doc(newPost.id).set(newPost.toJson());

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
      await postsCollectionRef.doc(postId).delete();

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
      final postDoc = await postsCollectionRef.doc(postId).get();
      if (!postDoc.exists) return Result.error(ErrorMsgs.cannotFetchPostError);

      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      final alreadyLiked = post.likes.contains(userId);
      alreadyLiked ? post.likes.remove(userId) : post.likes.add(userId);

      await postsCollectionRef.doc(postId).update({'likes': post.likes});

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
      // Get the post document from firestore
      final postDoc = await postsCollectionRef.doc(postId).get();

      if (!postDoc.exists) {
        return Result.error(ErrorMsgs.cannotFetchPostError);
      }
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      // Add the new comment
      post.comments.add(comment);

      // Update the post document with the new comment
      await postsCollectionRef.doc(postId).update({
        'comments': post.comments.map((comment) => comment.toJson()).toList()
      });

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
      // Get the post document from firestore
      final postDoc = await postsCollectionRef.doc(postId).get();

      if (!postDoc.exists) {
        return Result.error(ErrorMsgs.cannotFetchPostError);
      }
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      // Remove the comment
      post.comments.removeWhere((comment) => comment.id == commentId);

      // Update the post document with the new comment
      await postsCollectionRef.doc(postId).update({
        'comments': post.comments.map((comment) => comment.toJson()).toList()
      });

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  List<Post> mapSnapshotToPosts(QuerySnapshot postSnapshot) {
    return postSnapshot.docs.map((document) {
      final data = document.data() as Map<String, dynamic>;
      return Post.fromJson(data);
    }).toList();
  }
}
