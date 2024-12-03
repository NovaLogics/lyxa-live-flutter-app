import 'package:lyxa_live/src/features/post/domain/entities/comment_entity.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class PostRepository {
  Future<Result<List<Post>>> getAllPosts();

  Future<Result<List<Post>>> getPostsForUser({
    required String userId,
  });

  Future<Result<void>> addPost({
    required Post newPost,
  });

  Future<Result<void>> removePost({
    required String postId,
  });

  Future<Result<void>> togglePostLike({
    required String postId,
    required String userId,
  });

  Future<Result<void>> addCommentToPost({
    required String postId,
    required CommentEntity comment,
  });

  Future<Result<void>> removeCommentFromPost({
    required String postId,
    required String commentId,
  });
}
