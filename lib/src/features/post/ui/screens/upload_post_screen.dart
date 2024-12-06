import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/resources/text_field_limits.dart';
import 'package:lyxa_live/src/features/home/cubits/home_cubit.dart';
import 'package:lyxa_live/src/features/profile/data/services/profile_service.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/widgets/custom_outlined_button.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_button.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';
import 'package:lyxa_live/src/shared/widgets/multiline_text_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/scrollable_scaffold.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class UploadPostScreen extends StatefulWidget {
  final VoidCallback onPostUploaded;

  const UploadPostScreen({
    super.key,
    required this.onPostUploaded,
  });

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final ProfileService _profileService;
  late final PostCubit _postCubit;
  late final HomeCubit _homeCubit;
  Uint8List? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initScreen();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _focusNode.dispose();
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
              addSpacing(height: AppDimens.size8),
              _buildPickImageButton(),
              addSpacing(height: AppDimens.size28),
              _buildCaptionInput(),
              addSpacing(height: AppDimens.size28),
              _buildActionButtonsRow(),
              addSpacing(height: AppDimens.size72),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is PostUploaded) {
          _homeCubit.getAllPosts();
          widget.onPostUploaded();
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

  void _initScreen() async {
    _profileService = getIt<ProfileService>();
    _postCubit = getIt<PostCubit>();
    _homeCubit = getIt<HomeCubit>();
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
      currentUser: _profileService.profileEntity,
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
    final String debugTag = (UploadPostScreen).toString();
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
    );
  }

  Widget _buildImagePreview() {
    return _selectedImage != null
        ? Padding(
            padding: const EdgeInsets.all(AppDimens.paddingRG8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 240,
              ),
              child: Image.memory(
                _selectedImage!,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
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
      child: CustomOutlinedButton(
        onPressed: () {
          _handleImageSelection();
        },
        text: AppStrings.pickImageButton,
        icon: Icon(
          Icons.filter,
          color: Theme.of(context).colorScheme.onSecondary,
          size: AppDimens.iconSizeSM24,
        ),
        borderColor: Theme.of(context).colorScheme.onSecondary,
        textStyle: AppStyles.buttonTextPrimary.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.w600,
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
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
              letterSpacing: AppDimens.letterSpacingPT05,
              shadows: AppStyles.shadowStyleEmpty,
            ),
          ),
          addSpacing(height: AppDimens.spacingSM4),
          MultilineTextFieldUnit(
            controller: _captionController,
            // labelText: AppStrings.captionLabel,
            focusNode: _focusNode,
            hintText: AppStrings.captionHint,
            maxLength: TextFieldLimits.postField,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.size12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomOutlinedButton(
            onPressed: () {
              _openLogoutDialog();
            },
            text: AppStrings.clearButton,
            icon: Icon(
              Icons.clear_all_rounded,
              color: Theme.of(context).colorScheme.onSecondary,
              size: AppDimens.iconSizeSM22,
            ),
            borderColor: Theme.of(context).colorScheme.onPrimary,
            textStyle: AppStyles.buttonTextPrimary.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppDimens.size16),
          GradientButtonV1(
            onTap: _handleUploadPost,
            text: AppStrings.uploadPostButton,
            icon: const Icon(
              Icons.arrow_circle_up_outlined,
              color: AppColors.whiteLight,
              size: AppDimens.actionIconSize26,
            ),
          )
        ],
      ),
    );
  }

  void _openLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        title: Text(
          AppStrings.clearButtonMsg,
          style:
              TextStyle(color: Theme.of(context).colorScheme.onInverseSurface),
        ),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(AppStrings.dialog);
              _focusNode.unfocus();
            },
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface),
            ),
          ),
          // SAVE/SUBMIT BUTTON
          TextButton(
            onPressed: () {
              setState(() {
                _captionController.text = '';
                _selectedImage = null;
              });
              Navigator.of(context, rootNavigator: true).pop(AppStrings.dialog);
              setState(() {
                _focusNode.unfocus();
              });
            },
            child: Text(
              AppStrings.yesSure,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
