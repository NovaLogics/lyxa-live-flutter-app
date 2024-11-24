import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/storage/domain/storage_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

// Post Cubit for State management
class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;
  final StorageRepository storageRepository;

  PostCubit({
    required this.postRepository,
    required this.storageRepository,
  }) : super(PostInitial());

  // Create a new post
  Future<void> createPost({
    required Post post,
    Uint8List? imageBytes,
  }) async {
    emit(PostUploading());

    // Upload image if provided and get the URL
    final imageUrl =
        await storageRepository.uploadPostImageWeb(imageBytes, post.id);

    try {
      // Update the post with the image URL
      final updatedPost = post.copyWith(imageUrl: imageUrl);

      // Create post in the backend
      final result = await postRepository.createPost(post: updatedPost);

      switch (result.status) {
        case Status.success:
          // Re-fetch all posts
          fetchAllPosts();
          break;

        case Status.error:
          //FIREBASE ERROR
          if (result.isFirebaseError()) {
            emit(PostError(getError(result.getFirebaseError())));
          }
          //GENERIC ERROR
          else if (result.isGenericError()) {
            ErrorHandler.handleError(
              result.error?.genericError?.error,
              onRetry: () {
                ErrorAlertCubit.hideErrorMessage();
              },
            );
          }
          break;
      }
    } catch (error) {
      emit(PostError(ErrorMessages.postCreationError));
    }
  }
  // Future<void> createPost({
  //   required Post post,
  //   String? imagePath,
  //   Uint8List? imageBytes,
  // }) async {
  //   String? imageUrl;
  //   try {
  //     // Handle image upload for mobile platforms (Using file path)
  //     if (imagePath != null) {
  //       emit(PostUploading());
  //       imageUrl =
  //           await storageRepository.uploadPostImageMobile(imagePath, post.id);
  //     }
  //     // Handle image upload for web platforms (Using file bytes)
  //     else if (imageBytes != null) {
  //       emit(PostUploading());
  //       imageUrl =
  //           await storageRepository.uploadPostImageWeb(imageBytes, post.id);
  //     }

  //     // Give image url to post
  //     final newPost = post.copyWith(imageUrl: imageUrl);

  //     // Create post in the backend
  //     postRepository.createPost(post: newPost);

  //     // Re-fetch all posts
  //     fetchAllPosts();
  //   } catch (error) {
  //     emit(PostError('Failed to create post : ${error.toString()}'));
  //   }
  // }

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
      // await postRepository.deletePost(postId);
    } catch (error) {
      emit(PostError('Failed to delete post : ${error.toString()}'));
    }
  }

  // Toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      //  await postRepository.toggleLikePost(postId, userId);
    } catch (error) {
      emit(PostError('Failed to toggle like: ${error.toString()}'));
    }
  }

  // Add comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      //  await postRepository.addComment(postId, comment);
    } catch (error) {
      emit(PostError('Failed to add comment: ${error.toString()}'));
    }
  }

  // Delete comment to a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      // await postRepository.deleteComment(postId, commentId);
    } catch (error) {
      emit(PostError('Failed to delete the comment: ${error.toString()}'));
    }
  }

  /// Helper ->
  String getError(String? message) {
    if (message != null && message.isNotEmpty) {
      return message.toString().replaceFirst('Exception: ', '');
    } else {
      return ErrorMessages.unexpectedError;
    }
  }
}
