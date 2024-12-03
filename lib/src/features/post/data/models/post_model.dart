import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/features/post/data/models/comment_model.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment_entity.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';

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

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImageUrl;
  final String captionText;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<CommentEntity> comments;

  PostModel({
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

  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userProfileImageUrl,
    String? captionText,
    String? imageUrl,
    DateTime? timestamp,
    List<String>? likes,
    List<CommentEntity>? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      captionText: captionText ?? this.captionText,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  /// Converts `PostModel` to domain entity.
  PostEntity toEntity() {
    return PostEntity(
      id: id,
      userId: userId,
      userName: userName,
      userProfileImageUrl: userProfileImageUrl,
      captionText: captionText,
      imageUrl: imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

  /// Creates a `PostModel` from domain entity.
  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userProfileImageUrl: entity.userProfileImageUrl,
      captionText: entity.captionText,
      imageUrl: entity.imageUrl,
      timestamp: entity.timestamp,
      likes: entity.likes,
      comments: entity.comments,
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
      PostFields.comments: comments
          .map((comment) => CommentModel.fromEntity(comment).toJson())
          .toList(),
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final List<CommentEntity> comments = (json[PostFields.comments]
                as List<dynamic>?)
            ?.map(
                (commentJson) => CommentModel.fromJson(commentJson).toEntity())
            .toList() ??
        List.empty();

    return PostModel(
      id: json[PostFields.id] ?? '',
      userId: json[PostFields.userId] ?? '',
      userName: json[PostFields.userName] ?? '',
      userProfileImageUrl: json[PostFields.userProfileImageUrl] ?? '',
      captionText: json[PostFields.captionText] ?? json['text'] ?? '',
      imageUrl: json[PostFields.imageUrl] ?? '',
      timestamp: (json[PostFields.timestamp] as Timestamp).toDate(),
      likes: List<String>.from(json[PostFields.likes] ?? []),
      comments: comments,
    );
  }

  static PostModel getDefault() {
    return PostModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: '',
      userName: '',
      userProfileImageUrl: '',
      captionText: '',
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: List.empty(),
      comments: List.empty(),
    );
  }
}
