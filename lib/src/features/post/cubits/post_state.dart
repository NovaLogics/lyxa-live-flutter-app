import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostUploading extends PostState {}

class PostUploaded extends PostState {}

class PostLoaded extends PostState {
  final List<PostEntity> posts;
  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class PostErrorToast extends PostState {
  final String message;
  PostErrorToast(this.message);
}

class PostErrorException extends PostState {
  final Object? error;
  PostErrorException(this.error);
}
