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
import 'package:lyxa_live/src/shared/handlers/loading/widgets/center_loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/multiline_text_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/scrollable_scaffold.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class UploadPostScreen extends StatefulWidget {
  final ProfileUser? profileUser;

  const UploadPostScreen({
    super.key,
    required this.profileUser,
  });

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final TextEditingController captionController = TextEditingController();
  Uint8List? selectedImage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading || state is PostUploading) {
          return _buildLoadingScreen();
        }
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
        if (state is PostLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
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
          selectedImage = pickedFile.files.single.bytes;
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
        selectedImage = compressedImage;
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

  /// Handles post creation and upload
  void _createAndUploadPost() {
    final caption = captionController.text.trim();

    if (selectedImage == null || caption.isEmpty) {
      ToastMessengerUnit.showToast(
        context: context,
        message: AppStrings.errorImageAndCaptionRequired,
        icon: Icons.error,
        backgroundColor: AppColors.bluePurple900L1,
        textColor: AppColors.whiteShade,
      );
      return;
    }

    final post = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: widget.profileUser!.uid,
      userName: widget.profileUser!.name,
      userProfileImageUrl: widget.profileUser!.profileImageUrl,
      text: caption,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    context.read<PostCubit>().addPost(post: post, imageBytes: selectedImage);
  }

  Widget _buildLoadingScreen() {
    return getIt<CenterLoadingUnit>(param1: AppStrings.uploading);
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
    return selectedImage != null
        ? Padding(
            padding: const EdgeInsets.all(AppDimens.paddingRG8),
            child: Image.memory(
              selectedImage!,
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
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingLG24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            AppStrings.caption,
            style: AppTextStyles.subtitleSecondary,
          ),
          const SizedBox(height: AppDimens.spacingSM4),
          MultilineTextFieldUnit(
            controller: captionController,
            labelText: AppStrings.captionLabel,
            hintText: AppStrings.captionHint,
            maxLength: MAX_LENGTH_POST_FIELD,
          ),
        ],
      ),
    );
  }
}
