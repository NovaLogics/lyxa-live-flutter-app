import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment_entity.dart';

class CommentFields {
  static const String id = 'id';
  static const String postId = 'postId';
  static const String userId = 'userId';
  static const String userName = 'userName';
  static const String text = 'text';
  static const String timestamp = 'timestamp';
}

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

   @override
  String toString() {
    return toJson().toString();
  }

  // Factory to create CommentModel from JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json[CommentFields.id],
      postId: json[CommentFields.postId],
      userId: json[CommentFields.userId],
      userName: json[CommentFields.userName],
      text: json[CommentFields.text],
      timestamp: (json[CommentFields.timestamp] as Timestamp).toDate(),
    );
  }

  // Method to convert CommentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      CommentFields.id: id,
      CommentFields.postId: postId,
      CommentFields.userId: userId,
      CommentFields.userName: userName,
      CommentFields.text: text,
      CommentFields.timestamp: Timestamp.fromDate(timestamp),
    };
  }

  // Method to map CommentModel to a domain entity (Comment)
  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      postId: postId,
      userId: userId,
      userName: userName,
      text: text,
      timestamp: timestamp,
    );
  }

  // Method to create CommentModel from a domain entity (Comment)
  factory CommentModel.fromEntity(CommentEntity comment) {
    return CommentModel(
      id: comment.id,
      postId: comment.postId,
      userId: comment.userId,
      userName: comment.userName,
      text: comment.text,
      timestamp: comment.timestamp,
    );
  }
}
