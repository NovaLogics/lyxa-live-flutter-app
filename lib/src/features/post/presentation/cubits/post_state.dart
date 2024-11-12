import 'package:lyxa_live/src/features/post/domain/entities/post.dart';

abstract class PostState {}

// Initial
class PostInitial extends PostState {}

// Loading
class PostLoading extends PostState {}

// Uploading
class PostUploading extends PostState {}

// Loaded
class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

// Error
class PostError extends PostState {
  final String message;
  PostError(this.message);
}