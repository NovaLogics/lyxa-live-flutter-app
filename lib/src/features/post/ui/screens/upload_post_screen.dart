import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/helper/logger.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';

import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';
import 'package:lyxa_live/src/shared/widgets/multiline_text_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/scrollable_scaffold.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  late final AuthCubit authCubit = context.read<AuthCubit>();
  late AppUser? currentUser = authCubit.currentUser;

  Uint8List? selectedImage; // Selected image bytes for web

  final TextEditingController captionController = TextEditingController();

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  /// Handles image selection, cropping, and compression
  Future<void> handleImageSelection() async {
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
    } catch (e) {
      Logger.logError(e.toString());
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

  /// Returns platform-specific image cropper settings
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
  void createAndUploadPost() {
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
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: caption,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    context.read<PostCubit>().createPost(post, imageBytes: selectedImage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading || state is PostUploading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          body: Stack(
            children: [
              _buildBackground(),
              _buildUploadPage(),
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

  Widget _buildBackground() {
    return RepaintBoundary(
      child: getIt<GradientBackgroundUnit>(
        param1: AppDimens.containerSize400,
        param2: BackgroundStyle.home,
      ),
    );
  }

  Widget _buildUploadPage() {
    return ScrollableScaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createPost),
        actions: [
          IconButton(
            onPressed: createAndUploadPost,
            icon: const Icon(Icons.upload),
          )
        ],
      ),
      body: Column(
        children: [
          _buildImagePreview(),
          _buildPickImageButton(),
          const SizedBox(height: AppDimens.spacingXL28),
          _buildCaptionInput(),
          const SizedBox(height: AppDimens.size72),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return selectedImage != null
        ? Padding(
            padding: const EdgeInsets.all(AppDimens.paddingRG8),
            child: Image.memory(selectedImage!,
                width: double.infinity, fit: BoxFit.contain),
          )
        : Icon(Icons.image,
            size: AppDimens.imageSize180,
            color: Theme.of(context).colorScheme.outline);
  }

  Widget _buildPickImageButton() {
    return Center(
      child: GradientButton(
        text: AppStrings.pickImageButton.toUpperCase(),
        onPressed: handleImageSelection,
        textStyle: AppTextStyles.buttonTextPrimary.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        icon: Icon(Icons.filter,
            color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }

  Widget _buildCaptionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingLG24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(AppStrings.caption,
              style: AppTextStyles.subtitleSecondary),
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
