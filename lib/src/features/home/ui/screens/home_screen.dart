import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_unit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';
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
  late final AppUser _currentAppUser;
  ProfileUser? _profileUser;

  @override
  void initState() {
    super.initState();
    _postCubit = getIt<PostCubit>();
    _fetchAllPosts();
    _fetchCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      // App Bar
      appBar: _buildAppBar(context),
      // Drawer
      drawer: _buildAppDrawer(),
      // Body
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          LoadingCubit.hideLoading();
          Logger.logDebug(state.toString());
          if (state is PostLoading || state is PostUploading) {
            LoadingCubit.showLoading(message: AppStrings.loadingMessage);
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

  void _fetchCurrentUserData() async {
    try {
      LoadingCubit.showLoading(message: AppStrings.loadingMessage);

      ProfileCubit profileCubit = getIt<ProfileCubit>();

      final currentUser = getIt<AuthCubit>().currentUser;
      if (currentUser == null) {
        throw Exception(ErrorMessages.cannotFetchProfileError);
      }

      _currentAppUser = currentUser;

      final profileUser =
          await profileCubit.getUserProfile(_currentAppUser.uid);

      setState(() {
        if (profileUser != null) {
          _profileUser = profileUser;
        }
      });
    } catch (error) {
      ErrorHandler.handleError(
        error,
        onRetry: () {
          ErrorAlertCubit.hideErrorMessage();
        },
      );
    }
    LoadingCubit.hideLoading();
  }

  void _fetchAllPosts() {
    _postCubit.fetchAllPosts();
  }

  void _deletePost(String postId) {
    _postCubit.deletePost(postId);
    _fetchAllPosts();
  }

  void _navigateToUploadPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadPostScreen(
          profileUser: _profileUser,
        ),
      ),
    );
  }

  Widget _buildAppDrawer() {
    return DrawerUnit(
      user: _profileUser,
    );
  }

  // App Bar
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

  // Post list display
  Widget _buildPostList(List<Post> posts) {
    return (posts.isEmpty)
        ? const Center(child: Text(AppStrings.noPostAvailableError))
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostTileUnit(
                post: post,
                currentAppUser: _currentAppUser,
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
