import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class PostRepository {
  Future<Result<List<Post>>> fetchAllPosts();

  Future<Result<List<Post>>> fetchPostsByUserId({
    required String userId,
  });

  Future<Result<void>> createPost({
    required Post post,
  });

  Future<Result<void>> deletePost({
    required String postId,
  });

  Future<Result<void>> toggleLikePost({
    required String postId,
    required String userId,
  });

  Future<Result<void>> addComment({
    required String postId,
    required Comment comment,
  });

  Future<Result<void>> deleteComment({
    required String postId,
    required String commentId,
  });
}
