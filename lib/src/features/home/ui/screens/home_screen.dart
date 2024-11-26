import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_unit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
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
  ProfileUser _currentUser = ProfileUser.getGuestUser();

  @override
  void initState() {
    super.initState();
    _postCubit = getIt<PostCubit>();
    _initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: _buildAppBar(context),
      drawer: _buildAppDrawer(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          _hideLoading();
          if (state is PostLoading) {
            _showLoading(AppStrings.loadingMessage);
            return const SizedBox();
          } else if (state is PostUploading) {
            _showLoading(AppStrings.uploading);
            return const SizedBox();
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

  void _showLoading(String message) {
    LoadingCubit.showLoading(message: message);
  }

  void _hideLoading() {
    LoadingCubit.hideLoading();
  }

  void _fetchAllPosts() {
    _postCubit.getAllPosts();
  }

  void _deletePost(String postId) {
    _postCubit.deletePost(postId: postId);
    _fetchAllPosts();
  }

  void _initScreen() async {
    _showLoading(AppStrings.loadingMessage);

    final profileUser = await _postCubit.getCurrentUser();

    setState(() {
      _currentUser = profileUser;
    });

    _hideLoading();

    _fetchAllPosts();
  }

  void _navigateToUploadPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadPostScreen(profileUser: _currentUser),
      ),
    );
  }

  Widget _buildAppDrawer() {
    return DrawerUnit(user: _currentUser);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text(AppStrings.homeTitle),
      actions: [
        IconButton(
          onPressed: _navigateToUploadPostScreen,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return (posts.isEmpty)
        ? const Center(child: Text(AppStrings.noPostAvailableError))
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostTileUnit(
                post: post,
                currentUser: _currentUser,
                onDeletePressed: () => _deletePost(post.id),
              );
            },
          );
  }

  Widget _buildErrorState(String errorMessage) {
    Logger.logError(errorMessage.toString());
    return Center(
      child: Text(errorMessage),
    );
  }
}
