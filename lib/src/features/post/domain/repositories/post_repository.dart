import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/shared/entities/result.dart';

abstract class PostRepository {
  Future<Result<List<Post>>> fetchAllPosts();

  Future<void> createPost(
    Post post,
  );

  Future<void> deletePost(
    String postId,
  );

  Future<Result<List<Post>>> fetchPostsByUserId(
    String userId,
  );

  Future<void> toggleLikePost(
    String postId,
    String userId,
  );

  Future<void> addComment(
    String postId,
    Comment comment,
  );

  Future<void> deleteComment(
    String postId,
    String commentId,
  );
}
