import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/auth/presentation/components/text_field_unit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/presentation/cubits/profile_state.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

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
  Uint8List? webImage;

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

  // Pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // Update profile button pressed
  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    // Prepare images & data
    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    //Update profile if there is something to update
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
          uid: uid,
          newBio: newBio,
          imageMobilePath: imageMobilePath,
          imageWebBytes: imageWebBytes);
    }
    // No data to update -> Go to previous page
    else {
      Navigator.pop(context);
    }
  }

  Widget _buildEditScreen() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(Icons.upload),
          )
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.hardEdge,
              child:
                  // Display selected image for mobile
                  (!kIsWeb && imagePickedFile != null)
                      ? Image.file(File(imagePickedFile!.path!))
                      :
                      // Display selected image for web
                      (kIsWeb && webImage != null)
                          ? Image.memory(
                              webImage!,
                              fit: BoxFit.cover,
                            )
                          :
                          // No image selected -> display existing profile pic
                          CachedNetworkImage(
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
          const SizedBox(height: 25),
          // Pick image button
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.teal,
              child: const Text("Pick Image"),
            ),
          ),
          // Bio section
          const SizedBox(height: 25),
          const Text("Bio"),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFieldUnit(
              controller: bioTextController,
              hintText: widget.user.bio,
              obscureText: false,
            ),
          )
        ],
      ),
    );
  }
}
