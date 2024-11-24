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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Path Firebase > posts
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection(FIRESTORE_COLLECTION_POSTS);

  @override
  Future<Result<List<Post>>> fetchAllPosts() async {
    try {
      // Get all posts with most recent posts at the top
      final postSnapshot =
          await postCollection.orderBy('timestamp', descending: true).get();

      // Convert each firestore document from json -> list of posts
      final List<Post> allPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

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
  Future<Result<List<Post>>> fetchPostsByUserId({
    required String userId,
  }) async {
    try {
      // Fetch posts snapshot with this uid
      final postSnapshot =
          await postCollection.where('userId', isEqualTo: userId).get();

      // Convert each firestore document from json -> list of posts
      final List<Post> userPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

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
  Future<Result<void>> createPost({
    required Post post,
  }) async {
    try {
      await postCollection.doc(post.id).set(post.toJson());

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> deletePost({
    required String postId,
  }) async {
    try {
      await postCollection.doc(postId).delete();

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> toggleLikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      // Get the post document from firestore
      final postDoc = await postCollection.doc(postId).get();

      if (!postDoc.exists) {
        return Result.error(ErrorMsgs.cannotFetchPostError);
      }
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      // Check if user has already like this post
      final hasLiked = post.likes.contains(userId);

      // Update the likes list
      if (hasLiked) {
        post.likes.remove(userId);
      } else {
        post.likes.add(userId);
      }

      // Update the post document with the new like list
      await postCollection.doc(postId).update({'likes': post.likes});

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<void>> addComment({
    required String postId,
    required Comment comment,
  }) async {
    try {
      // Get the post document from firestore
      final postDoc = await postCollection.doc(postId).get();

      if (!postDoc.exists) {
        return Result.error(ErrorMsgs.cannotFetchPostError);
      }
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      // Add the new comment
      post.comments.add(comment);

      // Update the post document with the new comment
      await postCollection.doc(postId).update({
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
  Future<Result<void>> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      // Get the post document from firestore
      final postDoc = await postCollection.doc(postId).get();

      if (!postDoc.exists) {
        return Result.error(ErrorMsgs.cannotFetchPostError);
      }
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      // Remove the comment
      post.comments.removeWhere((comment) => comment.id == commentId);

      // Update the post document with the new comment
      await postCollection.doc(postId).update({
        'comments': post.comments.map((comment) => comment.toJson()).toList()
      });

      return Result.voidSuccess();
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }
}
