import 'package:cloud_firestore/cloud_firestore.dart';

class CommentFields {
  static const String id = 'id';
  static const String postId = 'postId';
  static const String userId = 'userId';
  static const String userName = 'userName';
  static const String text = 'text';
  static const String timestamp = 'timestamp';
}

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

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

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json[CommentFields.id],
      postId: json[CommentFields.postId],
      userId: json[CommentFields.userId],
      userName: json[CommentFields.userName],
      text: json[CommentFields.text],
      timestamp: (json[CommentFields.timestamp] as Timestamp).toDate(),
    );
  }
}
