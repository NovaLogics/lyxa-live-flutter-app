import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/resources/text_field_limits.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/loading_unit.dart';
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
  final bioTextController = TextEditingController();
  late final ProfileCubit _profileCubit;
  Uint8List? _selectedImage;

  @override
  void initState() {
    super.initState();
    _profileCubit = getIt<ProfileCubit>();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Stack(
          children: [
            _buildEditScreen(),
            _buildLoadingScreen(),
          ],
        );
      },
      listener: (context, state) {
        // Show Error
        if (state is ProfileError) {
          ToastMessengerUnit.showErrorToast(
            context: context,
            message: state.message,
          );
        } else if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Future<void> _handleImageSelection() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: kIsWeb,
      );

      final processedImage = await _profileCubit.getProcessedImage(
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

  Widget _buildEditScreen() {
    bioTextController.text = widget.currentUser.bio;
    return ScrollableScaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: AppDimens.size24),
          _buildProfileImage(),
          const SizedBox(height: AppDimens.size24),
          _buildPickImageButton(),
          const SizedBox(height: AppDimens.size24),
          _buildBioSection(),
          const SizedBox(height: AppDimens.size72),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppStrings.editProfile),
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      actions: [
        IconButton(
          onPressed: updateProfile,
          icon: const Icon(Icons.upload),
        ),
      ],
    );
  }

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    final String uid = widget.currentUser.uid;
    final String? newBio = bioTextController.text.isNotEmpty
        ? bioTextController.text.toString().trim()
        : null;

    if (_selectedImage != null || newBio != null) {
      profileCubit.updateProfile(
          userId: uid, updatedBio: newBio, imageBytes: _selectedImage);
    } else {
      Navigator.pop(context);
    }
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
              color: Theme.of(context).colorScheme.surfaceContainer,
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
        text: AppStrings.pickImage.toUpperCase(),
        onPressed: _handleImageSelection,
        textStyle: AppStyles.buttonTextPrimary.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        icon: Icon(Icons.filter,
            color: Theme.of(context).colorScheme.inversePrimary),
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
              shadows: [],
            ),
          ),
          const SizedBox(height: AppDimens.size12),
          MultilineTextFieldUnit(
            controller: bioTextController,
            labelText: AppStrings.storyline,
            hintText: AppStrings.addYourStorylineBio,
            maxLength: TextFieldLimits.bioDescriptionField,
          ),
        ],
      ),
    );
  }
}
