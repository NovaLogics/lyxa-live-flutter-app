import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/firebase_error_handler.dart';

class FirebasePostRepository implements PostRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Path Firebase > posts
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection(FIRESTORE_COLLECTION_POSTS);

  @override
  Future<Result<bool>> createPost({
    required Post post,
  }) async {
    try {
      await postCollection.doc(post.id).set(post.toJson());
      return Result.success(true);
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(error);
    }
    // catch (error) {
    //   throw Exception('Error creating post : ${error.toString()}');
    // }
  }

  @override
  Future<void> deletePost({
    required String postId,
  }) async {
    try {
      await postCollection.doc(postId).delete();
    } catch (error) {
      throw Exception('Error deleting post : ${error.toString()}');
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // Get all posts with most recent posts at the top
      final postSnapshot =
          await postCollection.orderBy('timestamp', descending: true).get();

      // Convert each firestore document from json -> list of posts
      final List<Post> allPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (error) {
      throw Exception('Error fetching post : ${error.toString()}');
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId({
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

      return userPosts;
    } catch (error) {
      throw Exception('Error fetching posts by user : ${error.toString()}');
    }
  }

  @override
  Future<void> toggleLikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      // Get the post document from firestore
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Check if user has already like this post
        final hasLiked = post.likes.contains(userId);

        // Update the likes list
        if (hasLiked) {
          post.likes.remove(userId); // Unlike
        } else {
          post.likes.add(userId); // Like
        }

        // Update the post document with the new like list
        await postCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception('Post not found');
      }
    } catch (error) {
      throw Exception('Error toggling like: ${error.toString()}');
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required Comment comment,
  }) async {
    try {
      // Get the post document from firestore
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Add the new comment
        post.comments.add(comment);

        // Update the post document with the new comment
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception('Post not found');
      }
    } catch (error) {
      throw Exception('Error adding comment: ${error.toString()}');
    }
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      // Get the post document from firestore
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Remove the comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        // Update the post document with the new comment
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception('Post not found');
      }
    } catch (error) {
      throw Exception('Error deleting comment: ${error.toString()}');
    }
  }
}
