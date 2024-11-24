import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';

class PostFields {
  static const String id = 'id';
  static const String userId = 'userId';
  static const String userName = 'userName';
  static const String userProfileImageUrl = 'userProfileImageUrl';
  static const String text = 'text';
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
  final String text;
  final String imageUrl;
  final DateTime timestamp;

  final List<String> likes; // Store uIds
  final List<Comment> comments; // Store comment objects

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileImageUrl,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      userProfileImageUrl: userProfileImageUrl,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

  //Convert Post -> json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfileImageUrl': userProfileImageUrl,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

  //Convert json -> Post
  factory Post.fromJson(Map<String, dynamic> json) {
    // Prepare comments
    final List<Comment> comments = (json['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];

    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userProfileImageUrl: json['userProfileImageUrl'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(json['likes'] ?? []),
      comments: comments,
    );
  }
}
