import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/resources/text_field_limits.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/features/home/cubits/home_cubit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';
import 'package:lyxa_live/src/shared/widgets/multiline_text_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/scrollable_scaffold.dart';
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
  late final HomeCubit _homeCubit;
  Uint8List? _selectedImage;

  ProfileUser get _profileUser => widget.profileUser;

  @override
  void initState() {
    super.initState();
    _postCubit = getIt<PostCubit>();
    _homeCubit = getIt<HomeCubit>();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        return ScrollableScaffold(
          appBar: _buildAppBar(),
          body: Column(
            children: [
              _buildImagePreview(),
              _buildPickImageButton(),
              addSpacing(height: AppDimens.size28),
              _buildCaptionInput(),
              addSpacing(height: AppDimens.size72),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is PostUploaded) {
          _homeCubit.getAllPosts();
          Navigator.pop(context);
        } else if (state is PostErrorToast) {
          _handleErrorToast(state.message);
        } else if (state is PostErrorException) {
          _handleExceptionMessage(error: state.error);
        } else if (state is PostError) {
          _handleExceptionMessage(message: state.message);
        }
      },
    );
  }

  Future<void> _handleImageSelection() async {
    final selectedImage = await _postCubit.getSelectedImage();
    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void _handleUploadPost() {
    _hideKeyboard();
    _postCubit.addPost(
      captionText: _captionController.text,
      imageBytes: _selectedImage,
      currentUser: _profileUser,
    );
  }

  void _handleErrorToast(String message) {
    _hideKeyboard();
    ToastMessengerUnit.showErrorToast(
      context: context,
      message: message,
    );
  }

  void _handleExceptionMessage({Object? error, String? message}) {
    _hideKeyboard();
    ErrorHandler.handleError(
      error,
      tag: debugTag,
      customMessage: message,
      onRetry: () {},
    );
  }

  void _hideKeyboard() => FocusScope.of(context).unfocus();

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      title: Center(
        child: Text(
          AppStrings.createPost,
          style: AppStyles.textAppBarStatic.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          onPressed: _handleUploadPost,
          icon: const Icon(Icons.upload),
        ),
        addSpacing(width: AppDimens.size12),
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
        : const Icon(
            Icons.image,
            size: AppDimens.imageSize180,
            color: AppColors.bluePurple400,
          );
  }

  Widget _buildPickImageButton() {
    return Center(
      child: GradientButton(
        text: AppStrings.pickImageButton,
        onPressed: _handleImageSelection,
        icon: const Icon(
          Icons.filter,
          color: AppColors.whiteLight,
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
          Text(
            AppStrings.caption,
            style: AppStyles.subtitleSecondary.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              shadows: AppStyles.shadowStyleEmpty,
            ),
          ),
          addSpacing(height: AppDimens.spacingSM4),
          MultilineTextFieldUnit(
            controller: _captionController,
            // labelText: AppStrings.captionLabel,
            hintText: AppStrings.captionHint,
            maxLength: TextFieldLimits.postField,
          ),
        ],
      ),
    );
  }
}
