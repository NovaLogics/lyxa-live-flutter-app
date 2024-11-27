import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/resources/text_field_limits.dart';

import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/loading_unit.dart';
import 'package:lyxa_live/src/shared/spacers_unit.dart';
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
  static const String debugTag = 'UploadPostScreen';
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

  Future<void> _handleImageSelection() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: kIsWeb,
      );

      final processedImage = await _postCubit.getProcessedImage(
        pickedFile: pickedFile,
        isWebPlatform: kIsWeb,
      );

      if (processedImage == null) throw Exception(ErrorMsgs.imageFileEmpty);

      setState(() {
        _selectedImage = processedImage;
      });
    } catch (error) {
      ErrorHandler.handleError(
        error,
        tag: debugTag,
        onRetry: () {},
      );
    }
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

    final newPost = Post.getDefault().copyWith(
      userId: profileUser.uid,
      userName: profileUser.name,
      userProfileImageUrl: profileUser.profileImageUrl,
      captionText: captionText,
    );

    _postCubit.addPost(
      post: newPost,
      imageBytes: _selectedImage,
    );
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
        if (state is PostLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return BlocConsumer<LoadingCubit, LoadingState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Visibility(
          visible: state.isVisible,
          child: LoadingUnit(
            message: state.message,
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppStrings.createPost),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
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
            style: AppStyles.subtitleSecondary,
          ),
          addSpacing(height: AppDimens.spacingSM4),
          MultilineTextFieldUnit(
            controller: _captionController,
            labelText: AppStrings.captionLabel,
            hintText: AppStrings.captionHint,
            maxLength: TextFieldLimits.postField,
          ),
        ],
      ),
    );
  }
}
