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

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  late final authCubit = context.read<AuthCubit>();
  // Mobile Image Pick
  PlatformFile? imagePickedFile;

  // Web Image Pick
  Uint8List? pickedImage;

  //Bio Text Controller
  final textController = TextEditingController();

  // Current user
  // AppUser? currentUser;
  late AppUser? currentUser = authCubit.currentUser;

  // On Startup
  @override
  void initState() {
    super.initState();

    // getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // Pick image
  Future<void> pickCropCompressImage() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: kIsWeb,
      );

      if (pickedFile == null) return;

      // Platform -> WEB
      if (kIsWeb) {
        setState(() {
          pickedImage = pickedFile.files.single.bytes;
        });
      }
      // Platform -> MOBILE
      else {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.files.single.path!,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 95,
          uiSettings: _getCropperSettings(),
        );

        if (croppedFile == null) return;

        final compressedImage = await compressImage(croppedFile.path);
        if (compressedImage != null) {
          setState(() {
            pickedImage = compressedImage;
          });
          Logger.logDebug(AppStrings.imagePickedSuccessfully);
        }
      }
    } catch (error) {
      Logger.logError(error.toString());
    }
  }

  List<PlatformUiSettings> _getCropperSettings() {
    return [
      AndroidUiSettings(
        toolbarTitle: AppStrings.cropperToolbarTitle,
        toolbarColor: Colors.deepPurple,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        cropStyle: CropStyle.circle,
        lockAspectRatio: true,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      ),
      IOSUiSettings(
        title: AppStrings.cropperTitle,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square
        ],
      ),
    ];
  }

  Future<Uint8List?> compressImage(String filePath) async {
    return await FlutterImageCompress.compressWithFile(
      filePath,
      minWidth: 800,
      minHeight: 800,
      quality: 85,
    );
  }

  // Create & upload post
  void uploadPost() async {
    final text = textController.text.trim();

    Logger.logDebug('currentUser : ${currentUser!.toString()}');

    // Check if both image and caption are provided
    if (imagePickedFile == null || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Both image and caption are required"),
        ),
      );

      return;
    }

    // Create a new Post
    final newPost = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // PostCubit
    final postCubit = context.read<PostCubit>();

    postCubit.createPost(
      newPost,
      imageBytes: pickedImage,
    );

    // // Upload Web
    // if (kIsWeb) {
    //   postCubit.createPost(
    //     newPost,
    //     imageBytes: imagePickedFile?.bytes,
    //   );
    // }
    // // Upload Mobile
    // else {
    //   postCubit.createPost(
    //     newPost,
    //     imagePath: imagePickedFile?.path,
    //   );
    // }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        Logger.logDebug(state.toString());
        // Loading or Uploading
        if (state is PostLoading || state is PostUploading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Build upload page
        return Scaffold(
          body: Stack(
            children: [
              _buildBackground(),
              _buildUploadPage(),
            ],
          ),
        );
      },
      // Go to previous screen when upload is done & posts are loaded
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

  Widget _buildPickImageButton() {
    return Center(
      child: GradientButton(
        text: AppStrings.pickImage.toUpperCase(),
        onPressed: pickCropCompressImage,
        textStyle: AppTextStyles.buttonTextPrimary.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        icon: Icon(Icons.filter,
            color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }

  Widget _buildCaptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.size24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Caption',
            style: AppTextStyles.subtitleSecondary.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              shadows: [],
            ),
          ),
          const SizedBox(height: AppDimens.size4),
          MultilineTextFieldUnit(
            controller: textController,
            labelText: 'Caption area',
            hintText: 'Add post caption here..',
            maxLength: MAX_LENGTH_POST_FIELD,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadPage() {
    return ScrollableScaffold(
      // App Bar
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Create Post"),
        actions: [
          // Upload button
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.upload),
          )
        ],
      ),
      // Body
      body: Column(
        children: [
          // Image preview for web
          (pickedImage != null)
              ? Image.memory(
                  pickedImage!,
                  width: AppDimens.imageSize180,
                  height: AppDimens.imageSize180,
                  fit: BoxFit.cover,
                )
              : Icon(
                  Icons.image,
                  size: AppDimens.imageSize180,
                  color: Theme.of(context).colorScheme.outline,
                ),

          // Pick image button
          _buildPickImageButton(),
          const SizedBox(height: AppDimens.size28),

          // Caption Text
          _buildCaptionSection(),
        ],
      ),
    );
  }
}
