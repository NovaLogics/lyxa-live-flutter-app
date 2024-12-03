import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/post/data/models/post_model.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment_entity.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/storage/domain/repositories/storage_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';

class PostCubit extends Cubit<PostState> {
  static const String debugTag = 'PostCubit';
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;

  PostCubit({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
  })  : _storageRepository = storageRepository,
        _postRepository = postRepository,
        super(PostInitial());

  Future<ProfileUser> getCurrentUser() async {
    _showLoading(AppStrings.loadingMessage);
    final profileUser = await getIt<ProfileCubit>().getCurrentUser();
    _hideLoading();
    return profileUser;
  }

  Future<void> getAllPosts() async {
    _showLoading(AppStrings.loadingMessage);

    final getPostsResult = await _postRepository.getAllPosts();

    switch (getPostsResult.status) {
      case Status.success:
        emit(PostLoaded(getPostsResult.data ?? List.empty()));
        break;

      case Status.error:
        _handleErrors(
          result: getPostsResult,
          tag: '$debugTag: getAllPosts()',
        );
        break;
    }
    _hideLoading();
  }

  Future<void> addPost({
    required String captionText,
    Uint8List? imageBytes,
    required ProfileUser currentUser,
  }) async {
    final trimmedCaption = captionText.trim();

    if (imageBytes == null || trimmedCaption.isEmpty) {
      emit(PostErrorToast(AppStrings.errorImageAndCaptionRequired));
      return;
    }

    _showLoading(AppStrings.uploading);

    final newPost = PostModel.getDefault().copyWith(
      userId: currentUser.uid,
      userName: currentUser.name,
      userProfileImageUrl: currentUser.profileImageUrl,
      captionText: captionText,
    );

    final imageUploadResult = await _storageRepository.uploadPostImage(
      imageFileBytes: imageBytes,
      fileName: newPost.id,
    );

    if (imageUploadResult.status == Status.error) {
      _handleErrors(
        result: imageUploadResult,
        tag: '$debugTag: addPost()::imageUploadResult',
      );
      _hideLoading();
      return;
    }

    newPost.copyWith(imageUrl: imageUploadResult.data);
    final updatedPost = newPost.toEntity();

    final postUploadResult =
        await _postRepository.addPost(newPost: updatedPost);

    switch (postUploadResult.status) {
      case Status.success:
        getAllPosts();
        break;

      case Status.error:
        _handleErrors(
          result: postUploadResult,
          tag: '$debugTag: addPost()::postUploadResult',
        );
        break;
    }
    _hideLoading();
  }

  Future<void> deletePost({
    required PostEntity post,
  }) async {
    final postDeleteResult = await _postRepository.removePost(postId: post.id);

    // final imageDeleteResult =
    await _storageRepository.deleteImageByUrl(downloadUrl: post.imageUrl);

    switch (postDeleteResult.status) {
      case Status.success:
        //TODO : Handle this
        getAllPosts();
        break;

      case Status.error:
        _handleErrors(
          result: postDeleteResult,
          tag: '$debugTag: deletePost()',
        );
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
          tag: '$debugTag: toggleLikePost()',
        );
        break;
    }
  }

  Future<void> addComment({
    required String postId,
    required CommentEntity comment,
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
          tag: '$debugTag: addComment()',
        );
        break;
    }
  }

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
          tag: '$debugTag: deleteComment()',
        );
        break;
    }
  }

  Future<Uint8List?> getSelectedImage() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: kIsWeb,
      );
      if (pickedFile == null) return null;

      if (kIsWeb) {
        // WEB
        return pickedFile.files.single.bytes;
      } else {
        // MOBILE
        final filePath = pickedFile.files.single.path!;
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: filePath,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: _getImageCropperSettings(),
        );

        if (croppedFile == null) return null;

        final compressedImage = await _compressImage(croppedFile.path);

        if (compressedImage == null) throw Exception(ErrorMsgs.imageFileEmpty);

        return compressedImage;
      }
    } catch (error) {
      emit(PostErrorException(error));
    }
    return null;
  }

  // HELPER FUNCTIONS ▼

  void _showLoading(String message) {
    LoadingCubit.showLoading(message: message);
  }

  void _hideLoading() {
    LoadingCubit.hideLoading();
  }

  void _handleErrors(
      {required Result result, String? prefixMessage, String? tag}) {
    // FIREBASE ERROR
    if (result.isFirebaseError()) {
      emit(PostErrorToast(result.getFirebaseAlert()));
    }
    // GENERIC ERROR
    else if (result.isGenericError()) {
      emit(PostErrorException(result.getGenericErrorData()));
    }
    // KNOWN ERRORS
    else if (result.isMessageError()) {
      emit(PostError(result.getMessageErrorAlert()));
    }
  }

  /// Returns platform specific image cropper settings
  List<PlatformUiSettings> _getImageCropperSettings() {
    return [
      AndroidUiSettings(
        toolbarTitle: AppStrings.cropperTitle,
        toolbarColor: Colors.deepPurple,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: true,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ],
      ),
      IOSUiSettings(
        title: AppStrings.cropperTitle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ],
      ),
    ];
  }

  /// Compresses image to reduce size
  Future<Uint8List?> _compressImage(String filePath) async {
    return await FlutterImageCompress.compressWithFile(
      filePath,
      minWidth: 800,
      minHeight: 800,
      quality: 90,
    );
  }
}
