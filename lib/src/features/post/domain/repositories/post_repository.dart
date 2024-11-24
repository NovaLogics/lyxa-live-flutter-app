import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class PostRepository {
  Future<Result<List<Post>>> fetchAllPosts();

  Future<Result<bool>> createPost({
    required Post post,
  });

  Future<void> deletePost({
    required String postId,
  });

  Future<Result<List<Post>>> fetchPostsByUserId({
    required String userId,
  });

  Future<void> toggleLikePost({
    required String postId,
    required String userId,
  });

  Future<void> addComment({
    required String postId,
    required Comment comment,
  });

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  });
}
