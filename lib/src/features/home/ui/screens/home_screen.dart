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
import 'package:lyxa_live/src/features/profile/cubits/profile_state.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
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
  late final AppUser _currentAppUser;
  ProfileUser? _profileUser;
  bool _isLodaingData = false;

  @override
  void initState() {
    super.initState();
    _postCubit = context.read<PostCubit>();
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


  void _fetchCurrentUserData() async {
    // Initialize cubits
    AuthCubit authCubit = context.read<AuthCubit>();
    ProfileCubit profileCubit = context.read<ProfileCubit>();

    // Ensure current user is not null
    final currentUser = authCubit.currentUser;
    if (currentUser == null) {
      throw Exception("No authenticated user found. Cannot fetch profile.");
    }

    // Set the current app user
    _currentAppUser = currentUser;

    // Log user ID
    Logger.logDebug("Current user ID: ${_currentAppUser.uid}");

    // Fetch profile for the given user ID
    profileCubit.fetchUserProfile(_currentAppUser.uid);
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
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          _isLodaingData = false;
        } else if (state is ProfileLoaded) {
          _profileUser = state.profileUser;
          _isLodaingData = false;
        } else {
          _isLodaingData = true;
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            _profileUser = state.profileUser;
            return DrawerUnit(
              user: _profileUser,
            );
          } else {
            return const DrawerUnit(
              user: null,
            );
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
      title: const Text(AppStrings.homeTitle),
      actions: [
        IconButton(
          onPressed: _navigateToUploadPostScreen,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  // Loading state widget
  Widget _buildLoadingState() {
    return getIt<CenterLoadingUnit>(param1: AppStrings.pleaseWait);
  }

  // Post list display
  Widget _buildPostList(List<Post> posts) {
    return Stack(
      children: [
        (posts.isEmpty)
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
              ),
        if (_isLodaingData) _buildLoadingState(),
      ],
    );
  }

  // Error state widget
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Text(errorMessage),
    );
  }
}
