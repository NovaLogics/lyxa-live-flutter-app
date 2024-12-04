import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/resources/text_field_limits.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';
import 'package:lyxa_live/src/shared/widgets/multiline_text_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/scrollable_scaffold.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_state.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileUser currentUser;

  const EditProfileScreen({
    super.key,
    required this.currentUser,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const String debugTag = 'EditProfileScreen';
  final TextEditingController bioTextController = TextEditingController();
  late final ProfileCubit _profileCubit;
  Uint8List? _selectedImage;

  ProfileUser get _currentUser => widget.currentUser;
  String get _bio => bioTextController.text.trim();

  @override
  void initState() {
    super.initState();
    _profileCubit = getIt<ProfileCubit>();
  }

  @override
  void dispose() {
    bioTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return _buildEditScreen();
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        } else if (state is ProfileErrorToast) {
          _handleErrorToast(state.message);
        } else if (state is ProfileErrorException) {
          _handleExceptionMessage(error: state.error);
        } else if (state is ProfileError) {
          _handleExceptionMessage(message: state.message);
        }
      },
    );
  }

  Future<void> _handleImageSelection() async {
    final selectedImage = await _profileCubit.getSelectedImage();
    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void _handleProfileUpdate() async {
    if (_selectedImage != null || _bio.isNotEmpty) {
       _hideKeyboard();

      _profileCubit.updateProfile(
        userId: _currentUser.uid,
        updatedBio: _bio,
        imageBytes: _selectedImage,
      );
    } else {
      Navigator.pop(context);
    }
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

  Widget _buildEditScreen() {
    bioTextController.text = widget.currentUser.bio;
    return ScrollableScaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          addSpacing(height: AppDimens.size24),
          _buildProfileImage(),
          addSpacing(height: AppDimens.size24),
          _buildPickImageButton(),
          addSpacing(height: AppDimens.size24),
          _buildBioSection(),
          addSpacing(height: AppDimens.size72),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      title: Center(
        child: Text(
          AppStrings.editProfile,
          style: AppStyles.textAppBarStatic.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: _handleProfileUpdate,
          icon: const Icon(Icons.upload),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Material(
        elevation: AppDimens.elevationSM2,
        shape: const CircleBorder(),
        color: Theme.of(context).colorScheme.outline,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            height: AppDimens.imageSize180,
            width: AppDimens.imageSize180,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.hardEdge,
            child: (_selectedImage != null)
                ? Image.memory(
                    _selectedImage!,
                    width: AppDimens.imageSize180,
                    height: AppDimens.imageSize180,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: widget.currentUser.profileImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      size: AppDimens.iconSizeXXL72,
                      color: AppColors.grayLight,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickImageButton() {
    return Center(
      child: GradientButton(
        text: AppStrings.pickImage,
        onPressed: _handleImageSelection,
        icon: const Icon(
          Icons.filter,
          color: AppColors.whiteLight,
        ),
      ),
    );
  }

  Widget _buildBioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.size32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.storylineDecoText,
            style: AppStyles.subtitleSecondary.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              shadows: AppStyles.shadowStyleEmpty,
            ),
          ),
          addSpacing(height: AppDimens.size12),
          MultilineTextFieldUnit(
            controller: bioTextController,
            // labelText: AppStrings.storyline,
            hintText: AppStrings.addYourStorylineBio,
            maxLength: TextFieldLimits.bioDescriptionField,
          ),
        ],
      ),
    );
  }
}
