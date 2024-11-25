import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';

import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/center_loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/multiline_text_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/scrollable_scaffold.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class UploadPostScreen extends StatefulWidget {
  final ProfileUser profileUser;

  const UploadPostScreen({
    super.key,
    required this.profileUser,
  });

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  late final PostCubit _postCubit;
  Uint8List? _selectedImage;

  ProfileUser get profileUser => widget.profileUser;

  @override
  void initState() {
    super.initState();
    _postCubit = getIt<PostCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildUploadPostScreen(),
        _buildLoadingScreen(),
      ],
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Widget _buildUploadPostScreen() {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        return ScrollableScaffold(
          appBar: _buildAppBar(),
          body: Column(
            children: [
              _buildImagePreview(),
              _buildPickImageButton(),
              const SizedBox(height: AppDimens.size28),
              _buildCaptionInput(),
              const SizedBox(height: AppDimens.size72),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is PostLoading) {
          return LoadingCubit.showLoading(message: AppStrings.loadingMessage);
        }
        if (state is PostUploading) {
          return LoadingCubit.showLoading(message: AppStrings.uploading);
        } else if (state is PostLoaded) {
          Navigator.pop(context);
        }
        LoadingCubit.hideLoading();
      },
    );
  }

  /// Handles image selection, cropping, and compression
  Future<void> _handleImageSelection() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: kIsWeb,
      );

      if (pickedFile == null) return;

      if (kIsWeb) {
        // Handle web image selection
        setState(() {
          _selectedImage = pickedFile.files.single.bytes;
        });
      } else {
        // Handle mobile image selection and cropping
        await _processMobileImage(pickedFile.files.single.path!);
      }
      Logger.logDebug(AppStrings.imagePickedSuccessfully);
    } catch (error) {
      Logger.logError(error.toString());
    }
  }

  /// Processes mobile images by cropping and compressing
  Future<void> _processMobileImage(String filePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 95,
      uiSettings: _getImageCropperSettings(),
    );

    if (croppedFile == null) return;

    final compressedImage = await _compressImage(croppedFile.path);
    if (compressedImage != null) {
      setState(() {
        _selectedImage = compressedImage;
      });
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
      quality: 85,
    );
  }

  void _createAndUploadPost() {
    final captionText = _captionController.text.trim();

    if (_selectedImage == null || captionText.isEmpty) {
      ToastMessengerUnit.showErrorToast(
        context: context,
        message: AppStrings.errorImageAndCaptionRequired,
      );
      return;
    }

    final post = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: profileUser.uid,
      userName: profileUser.name,
      userProfileImageUrl: profileUser.profileImageUrl,
      captionText: captionText,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    _postCubit.addPost(
      post: post,
      imageBytes: _selectedImage,
    );
  }

  Widget _buildLoadingScreen() {
    return BlocConsumer<LoadingCubit, LoadingState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isVisible,
          child: CenterLoadingUnit(
            message: state.message,
          ),
        );
      },
      listener: (BuildContext context, LoadingState state) {
        Logger.logDebug(state.isVisible.toString());
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppStrings.createPost),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          onPressed: _createAndUploadPost,
          icon: const Icon(Icons.upload),
        )
      ],
    );
  }

  Widget _buildImagePreview() {
    return _selectedImage != null
        ? Padding(
            padding: const EdgeInsets.all(AppDimens.paddingRG8),
            child: Image.memory(
              _selectedImage!,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          )
        : Icon(
            Icons.image,
            size: AppDimens.imageSize180,
            color: Theme.of(context).colorScheme.outline,
          );
  }

  Widget _buildPickImageButton() {
    return Center(
      child: GradientButton(
        text: AppStrings.pickImageButton.toUpperCase(),
        onPressed: _handleImageSelection,
        textStyle: AppTextStyles.buttonTextPrimary.copyWith(
          color: AppColors.whitePure,
        ),
        icon: const Icon(
          Icons.filter,
          color: AppColors.whitePure,
        ),
      ),
    );
  }

  Widget _buildCaptionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.size24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            AppStrings.caption,
            style: AppTextStyles.subtitleSecondary,
          ),
          const SizedBox(height: AppDimens.spacingSM4),
          MultilineTextFieldUnit(
            controller: _captionController,
            labelText: AppStrings.captionLabel,
            hintText: AppStrings.captionHint,
            maxLength: MAX_LENGTH_POST_FIELD,
          ),
        ],
      ),
    );
  }
}
