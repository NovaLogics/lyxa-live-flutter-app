import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_unit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/shared/widgets/center_loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/post_tile_unit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/post/ui/screens/upload_post_screen.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PostCubit _postCubit;

  @override
  void initState() {
    super.initState();
    _postCubit = context.read<PostCubit>();
    _fetchAllPosts();
  }

  void _fetchAllPosts() {
    _postCubit.fetchAllPosts();
  }

  void _deletePost(String postId) {
    _postCubit.deletePost(postId);
    _fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      // App Bar
      appBar: _buildAppBar(context),
      // Drawer
      drawer: const DrawerUnit(),
      // Body
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading || state is PostUploading) {
            return _buildLoadingState();
          } else if (state is PostLoaded) {
            return _buildPostList(state.posts);
          } else if (state is PostError) {
            return _buildErrorState(state.message);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  // App Bar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text(AppStrings.appName),
      actions: [
        IconButton(
          onPressed: _navigateToUploadPostScreen,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  // Navigate to Upload Post Screen
  void _navigateToUploadPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UploadPostScreen(),
      ),
    );
  }

  // Loading state widget
  Widget _buildLoadingState() {
    return getIt<CenterLoadingUnit>(param1: AppStrings.pleaseWaitMessage);
  }

  // Post list display
  Widget _buildPostList(List<Post> posts) {
    if (posts.isEmpty) {
      return const Center(
        child: Text(AppStrings.noPostAvailableError),
      );
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostTileUnit(
          post: post,
          onDeletePressed: () => _deletePost(post.id),
        );
      },
    );
  }

  // Error state widget
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Text(errorMessage),
    );
  }
}
