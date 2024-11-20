import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';
import 'package:lyxa_live/src/shared/widgets/multiline_text_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/scrollable_scaffold.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileUser user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Mobile Image Pick
  PlatformFile? imagePickedFile;

  // Web Image Pick
  // Uint8List? webImage;
  Uint8List? pickedImage;

  //Bio Text Controller
  final bioTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      // Profile loading
      if (state is ProfileLoading) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Updating...'),
              ],
            ),
          ),
        );
      }
      // Profile error

      // Edit screen
      else {
        return _buildEditScreen();
      }
    }, listener: (context, state) {
      if (state is ProfileError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
          ),
        );
      } else if (state is ProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> pickCropCompressImage() async {
    try {
      // Step 1: Pick the image using FilePicker
      final pickedFile =
          await FilePicker.platform.pickFiles(type: FileType.image, withData: kIsWeb);
      if (pickedFile == null) return; // User cancelled the picker

      if (kIsWeb) {
        setState(() {
          pickedImage = pickedFile.files.single.bytes;
        });
            } else {
        // Step 2: Crop the image using ImageCropper
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.files.single.path!,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 95,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Profile Image Cropper',
              toolbarColor: Colors.deepPurple,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              cropStyle: CropStyle.circle,
              lockAspectRatio: true,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
            //           WebUiSettings(
            //   context: context,
            //   presentStyle: WebPresentStyle.dialog,
            //   size: const CropperSize(
            //     width: 520,
            //     height: 520,
            //   ),
            // ),
          ],
        );

        if (croppedFile == null) return; // User cancelled cropping

        // Step 3: Compress the image using FlutterImageCompress
        final Uint8List? compressedImage =
            await FlutterImageCompress.compressWithFile(
          croppedFile.path,
          format: CompressFormat.jpeg,
          quality: 95,
        );

        if (compressedImage != null) {
          setState(() {
            pickedImage = compressedImage;
          });

          // Example: Upload or use the Uint8List (pickedImage)
          print("Image picked and compressed successfully!");
        }
      }
    } catch (e) {
      print("Error picking or compressing image: $e");
    }
  }


// Compress the image (For mobile: file path; for web: image data bytes)
  Future<Uint8List?> compressImage(String filePath) async {
    final result = await FlutterImageCompress.compressWithFile(
      filePath,
      minWidth: 800,
      minHeight: 800,
      quality: 85,
      rotate: 0,
    );

    return result;
  }

  // Update profile button pressed
  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    // Prepare images & data
    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    // final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    // final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    //Update profile if there is something to update
    if (pickedImage != null || newBio != null) {
      profileCubit.updateProfile(
          uid: uid,
          newBio: newBio,
          // imageMobilePath: imageMobilePath,
          imageWebBytes: pickedImage);
    }
    // No data to update -> Go to previous page
    else {
      Navigator.pop(context);
    }
  }

  Widget _buildEditScreen() {
    bioTextController.text = widget.user.bio;
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            child: getIt<GradientBackgroundUnit>(
              param1: AppDimens.containerSize400,
              param2: BackgroundStyle.home,
            ),
          ),
          ScrollableScaffold(
            appBar: AppBar(
              title: const Text("Edit Profile"),
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              actions: [
                IconButton(
                  onPressed: updateProfile,
                  icon: const Icon(Icons.upload),
                )
              ],
            ),
            body: Column(
              children: [
                const SizedBox(height: 25),
                Center(
                  child: Material(
                    elevation: AppDimens.elevationSmall,
                    shape: const CircleBorder(),
                    color: Theme.of(context).colorScheme.outline,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: (pickedImage != null)
                            ? Image.memory(
                                pickedImage!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.user.profileImageUrl,
                                // Loading
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                // Error -> Failed to load
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 72,
                                  color: Theme.of(context).colorScheme.primary,
                                ),

                                errorListener: (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(value.toString()))),

                                // Loaded
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Pick image button
                Center(
                  child: GradientButton(
                    text: 'Pick Image',
                    onPressed: pickCropCompressImage,
                    textStyle: AppTextStyles.buttonTextPrimary.copyWith(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    icon: Icon(
                      Icons.filter,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                // Bio section
                const SizedBox(height: 25),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDimens.size32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.storyline,
                        style: AppTextStyles.subtitleSecondary.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          shadows: AppTextStyles.shadowStyle2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.size12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: MultilineTextFieldUnit(
                    controller: bioTextController,
                    hintText: AppStrings.addYourStorylineBio,
                    maxLength: MAX_LENGTH_BIO_DESCRIPTION_FIELD,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
