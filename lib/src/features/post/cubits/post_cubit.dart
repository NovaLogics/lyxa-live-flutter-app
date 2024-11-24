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

class PostCubit extends Cubit<PostState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;

  PostCubit({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
  })  : _storageRepository = storageRepository,
        _postRepository = postRepository,
        super(PostInitial());

  Future<void> getAllPosts() async {
    emit(PostLoading());

    final result = await _postRepository.getAllPosts();

    switch (result.status) {
      case Status.success:
        emit(PostLoaded(result.data ?? List.empty()));
        break;

      case Status.error:
        _handleErrors(result: result);
        break;
    }
  }

  Future<void> addPost({
    required Post post,
    Uint8List? imageBytes,
  }) async {
    try {
      emit(PostUploading());

      final imageUrl =
          await _storageRepository.uploadPostImageWeb(imageBytes, post.id);

      final updatedPost = post.copyWith(imageUrl: imageUrl);

      final result = await _postRepository.addPost(newPost: updatedPost);

      switch (result.status) {
        case Status.success:
          getAllPosts();
          break;

        case Status.error:
          _handleErrors(result: result);
          break;
      }
    } catch (error) {
      emit(PostError(ErrorMsgs.postCreationError));
    }
  }

  Future<void> deletePost({
    required String postId,
  }) async {
    final result = await _postRepository.removePost(postId: postId);

    switch (result.status) {
      case Status.success:
        break;

      case Status.error:
        _handleErrors(result: result);
        break;
    }
  }

  Future<void> toggleLikePost({
    required String postId,
    required String userId,
  }) async {
    final result = await _postRepository.togglePostLike(
      postId: postId,
      userId: userId,
    );

    switch (result.status) {
      case Status.success:
        break;

      case Status.error:
        _handleErrors(
          result: result,
          prefixMessage: 'Failed to toggle like',
        );
        break;
    }
  }

  // Add comment to a post
  Future<void> addComment({
    required String postId,
    required Comment comment,
  }) async {
    final result = await _postRepository.addCommentToPost(
      postId: postId,
      comment: comment,
    );

    switch (result.status) {
      case Status.success:
        break;

      case Status.error:
        _handleErrors(
          result: result,
          prefixMessage: 'Failed to add comment',
        );
        break;
    }
  }

  // Delete comment to a post
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final result = await _postRepository.removeCommentFromPost(
      postId: postId,
      commentId: commentId,
    );

    switch (result.status) {
      case Status.success:
        break;

      case Status.error:
        _handleErrors(
          result: result,
          prefixMessage: 'Failed to delete the comment',
        );
        break;
    }
  }

  //-> Utils ->

  void _handleErrors({required Result result, String? prefixMessage}) {
    // FIREBASE ERROR
    if (result.isFirebaseError()) {
      emit(PostError(result.getFirebaseAlert()));
    }
    // GENERIC ERROR
    else if (result.isGenericError()) {
      ErrorHandler.handleError(
        result.getGenericErrorData(),
        prefixMessage: prefixMessage,
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
  }
}
