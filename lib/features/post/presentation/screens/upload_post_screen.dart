import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import 'package:lyxa_live/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/features/auth/presentation/components/text_field_unit.dart';
import 'package:lyxa_live/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/features/post/domain/entities/post.dart';
import 'package:lyxa_live/features/post/presentation/cubits/post_cubit.dart';
import 'package:lyxa_live/features/post/presentation/cubits/post_state.dart';

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
  Uint8List? webImage;

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
  void uploadPost() async {
    final text = textController.text;

    print('currentUser : ${currentUser!.toString()}');

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
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        if (kDebugMode) {
          print(state);
        }
        // Loading or Uploading
        if (state is PostLoading || state is PostUploading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Build upload page
        return _buildUploadPage();
      },
      // Go to previous screen when upload is done & posts are loaded
      listener: (context, state) {
        if (state is PostLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildUploadPage() {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
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
      body: Center(
        child: Column(
          children: [
            // Image preview for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            // Image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),

            // Pick image button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blueAccent,
              child: const Text('Pick Image'),
            ),

            // Caption Text
            TextFieldUnit(
              controller: textController,
              hintText: 'Caption',
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
