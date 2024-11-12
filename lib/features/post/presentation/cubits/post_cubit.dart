import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/features/post/domain/entities/post.dart';
import 'package:lyxa_live/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/features/post/presentation/cubits/post_state.dart';
import 'package:lyxa_live/features/storage/domain/storage_repository.dart';

// Post Cubit for State management
class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;
  final StorageRepository storageRepository;

  PostCubit({
    required this.postRepository,
    required this.storageRepository,
  }) : super(PostInitial());

  // Create a new post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;
    try {
      // Handle image upload for mobile platforms (Using file path)
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl =
            await storageRepository.uploadPostImageMobile(imagePath, post.id);
      }
      // Handle image upload for web platforms (Using file bytes)
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl =
            await storageRepository.uploadPostImageWeb(imageBytes, post.id);
      }

      // Give image url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      // Create post in the backend
      postRepository.createPost(newPost);

      // Re-fetch all posts
      fetchAllPosts();
    } catch (error) {
      emit(PostError('Failed to create post : ${error.toString()}'));
    }
  }

  // Fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepository.fetchAllPosts();
      emit(PostLoaded(posts));
    } catch (error) {
      emit(PostError('Failed to fetch posts : ${error.toString()}'));
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepository.deletePost(postId);
    } catch (error) {
      emit(PostError('Failed to delete post : ${error.toString()}'));
    }
  }

  // Toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepository.toggleLikePost(postId, userId);
    } catch (error) {
      emit(PostError('Failed to toggle like: ${error.toString()}'));
    }
  }

  // Add comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepository.addComment(postId, comment);

      await fetchAllPosts();
    } catch (error) {
      emit(PostError('Failed to add comment: ${error.toString()}'));
    }
  }

  // Delete comment to a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepository.deleteComment(postId, commentId);

      await fetchAllPosts();
    } catch (error) {
      emit(PostError('Failed to delete the comment: ${error.toString()}'));
    }
  }
}
