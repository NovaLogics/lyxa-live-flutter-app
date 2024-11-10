import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/features/auth/presentation/components/text_field_unit.dart';
import 'package:lyxa_live/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:lyxa_live/features/profile/presentation/cubits/profile_state.dart';

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

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    if (bioTextController.text.isNotEmpty) {
      profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text,
      );
    }
  }

  Widget _buildEditScreen({double uploadProgress = 0.0}) {
    return Scaffold(
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
          Text("Bio"),
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
