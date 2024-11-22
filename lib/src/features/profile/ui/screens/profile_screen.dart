import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/widgets/center_loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/post_tile_unit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/profile/ui/components/story_line_unit.dart';
import 'package:lyxa_live/src/features/profile/ui/components/follow_button_unit.dart';
import 'package:lyxa_live/src/features/profile/ui/components/profile_stats_unit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_state.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/edit_profile_screen.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/follower_screen.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  final String displayUserId;

  const ProfileScreen({super.key, required this.displayUserId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthCubit _authCubit;
  late final ProfileCubit _profileCubit;
  late final AppUser _currentAppUser;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(widget.displayUserId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return _buildProfileContent(context, state.profileUser);
        } else if (state is ProfileLoading) {
          return _buildLoadingScreen();
        } else {
          return const Scaffold(
            body: Center(
              child: Text(AppStrings.profileNotFoundError),
            ),
          );
        }
      },
    );
  }

  void _fetchUserProfile(String profileUserId) async {
    // Initialize cubits
    _authCubit = context.read<AuthCubit>();
    _profileCubit = context.read<ProfileCubit>();

    // Ensure current user is not null
    final currentUser = _authCubit.currentUser;
    if (currentUser == null) {
      throw Exception("No authenticated user found. Cannot fetch profile.");
    }

    // Set the current app user
    _currentAppUser = currentUser;

    // Log user ID
    Logger.logDebug("Current user ID: ${_currentAppUser.uid}");

    // Fetch profile for the given user ID
    _profileCubit.fetchUserProfile(profileUserId);
  }

  /// Handles the follow/unfollow button press.
  void _handleFollowButtonPressed() {
    final profileState = _profileCubit.state;

    if (profileState is! ProfileLoaded) return;

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(_currentAppUser.uid);

    // Optimistically update UI
    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(_currentAppUser.uid);
      } else {
        profileUser.followers.add(_currentAppUser.uid);
      }
    });

    // Perform follow/unfollow logic and handle errors
    _profileCubit
        .toggleFollow(_currentAppUser.uid, widget.displayUserId)
        .catchError((_) {
      // Revert optimistic UI changes if the operation fails
      setState(() {
        if (isFollowing) {
          profileUser.followers.add(_currentAppUser.uid);
        } else {
          profileUser.followers.remove(_currentAppUser.uid);
        }
      });
    });
  }

  Widget _buildLoadingScreen() {
    return getIt<CenterLoadingUnit>(param1: AppStrings.uploading);
  }

  Widget _buildProfileContent(BuildContext context, ProfileUser user) {
    final isOwnProfile = (widget.displayUserId == _currentAppUser.uid);
    Logger.logDebug(
        '$isOwnProfile  ${widget.displayUserId} = ${_currentAppUser.uid} ');

    return ConstrainedScaffold(
      appBar: _buildAppBar(context, user, isOwnProfile),
      body: ListView(
        children: [
          _buildProfilePicture(user),
          const SizedBox(height: AppDimens.size16),
          _buildEmailSection(user),
          const SizedBox(height: AppDimens.size8),
          _buildProfileStats(user),
          if (!isOwnProfile) const SizedBox(height: AppDimens.size8),
          if (!isOwnProfile) _buildFollowActionSection(user),
          const SizedBox(height: AppDimens.size12),
          _buildStoryLineSection(user.bio),
          const SizedBox(height: AppDimens.size24),
          _buildPostSection(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, ProfileUser user, bool isOwnProfile) {
    return AppBar(
      title: Center(
        child: Text(
          user.name,
          style: AppTextStyles.textStylePost.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: AppDimens.fontSizeXL20,
          ),
        ),
      ),
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        isOwnProfile
            ? IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(user: user),
                  ),
                ),
                icon: const Icon(Icons.settings_outlined),
                iconSize: AppDimens.iconSizeSM24,
              )
            : const SizedBox(
                width: AppDimens.iconSizeMD32,
              ),
      ],
    );
  }

  Widget _buildProfilePicture(ProfileUser user) {
    return Center(
      child: Material(
        elevation: AppDimens.elevationSM2,
        shape: const CircleBorder(),
        color: Theme.of(context).colorScheme.outline,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingXS1),
          child: CachedNetworkImage(
            imageUrl: user.profileImageUrl,
            placeholder: (_, __) => const CircularProgressIndicator(),
            errorWidget: (_, __, ___) => SizedBox(
              height: AppDimens.imageSize120,
              child: Icon(
                Icons.person_rounded,
                size: AppDimens.iconSizeXXL96,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            imageBuilder: (_, imageProvider) => Container(
              height: AppDimens.imageSize120,
              width: AppDimens.imageSize120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailSection(ProfileUser user) {
    return Center(
      child: Text(
        user.email,
        style: AppTextStyles.subtitlePrimary.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.normal,
          fontFamily: FONT_MONTSERRAT,
          shadows: AppTextStyles.shadowStyle2,
        ),
      ),
    );
  }

  Widget _buildProfileStats(ProfileUser user) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        int postCount = 0;

        if (state is PostLoaded) {
          postCount = state.posts
              .where((post) => post.userId == widget.displayUserId)
              .length;
        }

        return Padding(
          padding: const EdgeInsets.all(AppDimens.paddingRG8),
          child: ProfileStatsUnit(
            postCount: postCount,
            followerCount: user.followers.length,
            followingCount: user.following.length,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FollowerScreen(
                  followers: user.followers,
                  following: user.following,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFollowActionSection(ProfileUser user) {
    return FollowButtonUnit(
      onPressed: _handleFollowButtonPressed,
      isFollowing: user.followers.contains(_currentAppUser.uid),
    );
  }

  Widget _buildStoryLineSection(String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.size32),
          child: Text(
            AppStrings.storylineDecoText,
            style: AppTextStyles.subtitleSecondary.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w300,
              shadows: AppTextStyles.shadowStyle2,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.size8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.size24),
          child: Container(
            padding: const EdgeInsets.all(AppDimens.paddingXS1),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.deepPurpleAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
              ),
              child: StoryLineUnit(text: bio),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostSection(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoaded) {
          final userPosts = state.posts
              .where((post) => post.userId == widget.displayUserId)
              .toList();

          if (userPosts.isEmpty) {
            return const Center(child: Text(AppStrings.noPosts));
          }

          return ListView.builder(
            itemCount: userPosts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final post = userPosts[index];
              return PostTileUnit(
                post: post,
                currentAppUser: _currentAppUser,
                onDeletePressed: () =>
                    context.read<PostCubit>().deletePost(post.id),
              );
            },
          );
        } else if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text(AppStrings.failedToLoadPostError));
        }
      },
    );
  }
}
