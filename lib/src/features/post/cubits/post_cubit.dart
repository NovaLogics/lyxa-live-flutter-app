import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/storage/domain/storage_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
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
      final result = await postRepository.addPost(newPost: updatedPost);

      switch (result.status) {
        case Status.success:
          // Re-fetch all posts
          fetchAllPosts();
          break;

        case Status.error:
          // FIREBASE ERROR
          if (result.isFirebaseError()) {
            emit(PostError(result.getFirebaseAlert()));
          }
          // GENERIC ERROR
          else if (result.isGenericError()) {
            ErrorHandler.handleError(
              result.getGenericErrorData(),
              onRetry: () {},
            );
          }
          // KNOWN ERRORS
          else if (result.isMessageError()) {
            ErrorHandler.handleError(
              null,
              customMessage: result.getMessageErrorAlert(),
              onRetry: () {},
            );
          }
          break;
      }
    } catch (error) {
      emit(PostError(ErrorMsgs.postCreationError));
    }
  }

  // Fetch all posts
  Future<void> fetchAllPosts() async {
    emit(PostLoading());

    final result = await postRepository.getAllPosts();

    switch (result.status) {
      case Status.success:
        emit(PostLoaded(result.data ?? List.empty()));
        break;

      case Status.error:
        // FIREBASE ERROR
        if (result.isFirebaseError()) {
          emit(PostError(result.getFirebaseAlert()));
        }
        // GENERIC ERROR
        else if (result.isGenericError()) {
          ErrorHandler.handleError(
            result.getGenericErrorData(),
            onRetry: () {},
          );
        }
        // KNOWN ERRORS
        else if (result.isMessageError()) {
          ErrorHandler.handleError(
            null,
            customMessage: result.getMessageErrorAlert(),
            onRetry: () {},
          );
        }
        break;
    }
  }

  // Delete a post
  Future<void> deletePost({
    required String postId,
  }) async {
    final result = await postRepository.removePost(postId: postId);

    switch (result.status) {
      case Status.success:
        break;

      case Status.error:
        // FIREBASE ERROR
        if (result.isFirebaseError()) {
          emit(PostError(result.getFirebaseAlert()));
        }
        // GENERIC ERROR
        else if (result.isGenericError()) {
          ErrorHandler.handleError(
            result.getGenericErrorData(),
            prefixMessage: 'Failed to delete post',
            onRetry: () {},
          );
        }
        // KNOWN ERRORS
        else if (result.isMessageError()) {
          ErrorHandler.handleError(
            null,
            customMessage: result.getMessageErrorAlert(),
            onRetry: () {},
          );
        }
        break;
    }
  }

  // Toggle like on a post
  Future<void> toggleLikePost({
    required String postId,
    required String userId,
  }) async {
    final result = await postRepository.togglePostLike(
      postId: postId,
      userId: userId,
    );

    switch (result.status) {
      case Status.success:
        break;

      case Status.error:
        // FIREBASE ERROR
        if (result.isFirebaseError()) {
          emit(PostError(result.getFirebaseAlert()));
        }
        // GENERIC ERROR
        else if (result.isGenericError()) {
          ErrorHandler.handleError(
            result.getGenericErrorData(),
            prefixMessage: 'Failed to toggle like',
            onRetry: () {},
          );
        }
        // KNOWN ERRORS
        else if (result.isMessageError()) {
          ErrorHandler.handleError(
            null,
            customMessage: result.getMessageErrorAlert(),
            onRetry: () {},
          );
        }
        break;
    }
  }

  // Add comment to a post
  Future<void> addComment({
    required String postId,
    required Comment comment,
  }) async {
    final result = await postRepository.addCommentToPost(
      postId: postId,
      comment: comment,
    );

    switch (result.status) {
      case Status.success:
        break;

      case Status.error:
        // FIREBASE ERROR
        if (result.isFirebaseError()) {
          emit(PostError(result.getFirebaseAlert()));
        }
        // GENERIC ERROR
        else if (result.isGenericError()) {
          ErrorHandler.handleError(
            result.getGenericErrorData(),
            prefixMessage: 'Failed to add comment',
            onRetry: () {},
          );
        }
        // KNOWN ERRORS
        else if (result.isMessageError()) {
          ErrorHandler.handleError(
            null,
            customMessage: result.getMessageErrorAlert(),
            onRetry: () {},
          );
        }
        break;
    }
  }

  // Delete comment to a post
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final result = await postRepository.removeCommentFromPost(
      postId: postId,
      commentId: commentId,
    );

    switch (result.status) {
      case Status.success:
        break;

      case Status.error:
        // FIREBASE ERROR
        if (result.isFirebaseError()) {
          emit(PostError(result.getFirebaseAlert()));
        }
        // GENERIC ERROR
        else if (result.isGenericError()) {
          ErrorHandler.handleError(
            result.getGenericErrorData(),
            prefixMessage: 'Failed to delete the comment',
            onRetry: () {},
          );
        }
        // KNOWN ERRORS
        else if (result.isMessageError()) {
          ErrorHandler.handleError(
            null,
            customMessage: result.getMessageErrorAlert(),
            onRetry: () {},
          );
        }
        break;
    }
  }
}
