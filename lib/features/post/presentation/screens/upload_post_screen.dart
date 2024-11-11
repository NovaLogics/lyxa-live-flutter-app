import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import 'package:lyxa_live/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/features/post/domain/entities/post.dart';
import 'package:lyxa_live/features/post/presentation/cubits/post_cubit.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  // Mobile Image Pick
  PlatformFile? imagePickedFile;

  // Web Image Pick
  Uint8List? webImage;

  //Bio Text Controller
  final textController = TextEditingController();

  // Current user
  AppUser? currentUser;

  // On Startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
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

  // Create & upload post
  void updateProfile() async {
    final text = textController.text;
    // Check if both image and caption are provided
    if (imagePickedFile == null || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Both image and caption are required"),
        ),
      );
    }

    // Create a new Post
    final newPost = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: text,
      imageUrl: '',
      timestamp: DateTime.now(),
    );

    // PostCubit
    final postCubit = context.read<PostCubit>();

    // Upload Web
    if (kIsWeb) {
      postCubit.createPost(
        newPost,
        imageBytes: imagePickedFile?.bytes,
      );
    }
    // Upload Mobile
    else {
      postCubit.createPost(
        newPost,
        imagePath: imagePickedFile?.path,
      );
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Create Post"),
      ),
    );
  }
}
