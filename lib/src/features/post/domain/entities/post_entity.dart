import 'package:lyxa_live/src/features/post/domain/entities/comment_entity.dart';

class PostEntity {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImageUrl;
  final String captionText;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<CommentEntity> comments;

  PostEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileImageUrl,
    required this.captionText,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });
}
