import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';

class PostFields {
  static const String id = 'id';
  static const String userId = 'userId';
  static const String userName = 'userName';
  static const String userProfileImageUrl = 'userProfileImageUrl';
  static const String captionText = 'captionText';
  static const String imageUrl = 'imageUrl';
  static const String timestamp = 'timestamp';
  static const String likes = 'likes';
  static const String comments = 'comments';
}

class Post {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImageUrl;
  final String captionText;
  final String imageUrl;
  final DateTime timestamp;

  final List<String> likes; // Store uIds
  final List<Comment> comments; // Store comment objects

  Post({
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

  @override
  String toString() {
    return toJson().toString();
  }

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      userProfileImageUrl: userProfileImageUrl,
      captionText: captionText,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PostFields.id: id,
      PostFields.userId: userId,
      PostFields.userName: userName,
      PostFields.userProfileImageUrl: userProfileImageUrl,
      PostFields.captionText: captionText,
      PostFields.imageUrl: imageUrl,
      PostFields.timestamp: Timestamp.fromDate(timestamp),
      PostFields.likes: likes,
      PostFields.comments: comments.map((comment) => comment.toJson()).toList(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Comment> comments = (json[PostFields.comments] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];

    return Post(
      id: json[PostFields.id],
      userId: json[PostFields.userId],
      userName: json[PostFields.userName],
      userProfileImageUrl: json[PostFields.userProfileImageUrl],
      captionText: json[PostFields.captionText],
      imageUrl: json[PostFields.imageUrl],
      timestamp: (json[PostFields.timestamp] as Timestamp).toDate(),
      likes: List<String>.from(json[PostFields.likes] ?? []),
      comments: comments,
    );
  }
}
