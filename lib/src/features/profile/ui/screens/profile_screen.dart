import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
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
  late final String? _currentUserId;

  @override
  void initState() {
    super.initState();

    _authCubit = context.read<AuthCubit>();
    _profileCubit = context.read<ProfileCubit>();
    AppUser? currentUser = _authCubit.currentUser;
    _currentUserId = currentUser!.uid;

    _profileCubit.fetchUserProfile(widget.displayUserId);
  }

  /// Handles the follow/unfollow button press.
  void _handleFollowButtonPressed() {
    final profileState = _profileCubit.state;

    if (profileState is! ProfileLoaded) return;

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(_currentUserId);

    // Optimistically update UI
    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(_currentUserId!);
      } else {
        profileUser.followers.add(_currentUserId!);
      }
    });

    // Perform follow/unfollow logic and handle errors
    _profileCubit
        .toggleFollow(_currentUserId!, widget.displayUserId)
        .catchError((_) {
      // Revert optimistic UI changes if the operation fails
      setState(() {
        if (isFollowing) {
          profileUser.followers.add(_currentUserId);
        } else {
          profileUser.followers.remove(_currentUserId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOwnProfile = (widget.displayUserId == _currentUserId!);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return _buildProfileContent(context, state.profileUser, isOwnProfile);
        } else if (state is ProfileLoading) {
          return Scaffold(
            body:
                getIt<CenterLoadingUnit>(param1: AppStrings.pleaseWaitMessage),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text(AppStrings.profileNotFoundError)),
          );
        }
      },
    );
  }

  Widget _buildProfileContent(
      BuildContext context, ProfileUser user, bool isOwnProfile) {
    return ConstrainedScaffold(
      appBar: _buildAppBar(context, user, isOwnProfile),
      body: ListView(
        children: [
          _buildProfileHeader(user),
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
          '${user.name}    ',
          style: AppTextStyles.textStylePost.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: AppDimens.textSizeXL20,
          ),
        ),
      ),
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      actions: isOwnProfile
          ? [
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditProfileScreen(user: user)),
                ),
                icon: const Icon(Icons.settings_outlined),
              ),
            ]
          : null,
    );
  }

  Widget _buildProfileHeader(ProfileUser user) {
    return Column(
      children: [
        Material(
          elevation: AppDimens.elevationSmall,
          shape: const CircleBorder(),
          color: Theme.of(context).colorScheme.outline,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: CachedNetworkImage(
              imageUrl: user.profileImageUrl,
              placeholder: (_, __) => const CircularProgressIndicator(),
              errorWidget: (_, __, ___) => Icon(
                Icons.person_rounded,
                size: AppDimens.iconSize3XLarge,
                color: Theme.of(context).colorScheme.onSecondary,
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
        const SizedBox(height: AppDimens.size16),
        Text(
          user.email,
          style: AppTextStyles.subtitlePrimary.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.normal,
            fontFamily: FONT_MONTSERRAT,
            shadows: AppTextStyles.shadowStyle2,
          ),
        ),
      ],
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
          padding: const EdgeInsets.all(8.0),
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
      isFollowing: user.followers.contains(_currentUserId!),
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
              // fontFamily: FONT_DYNALIGHT,
              // fontSize: 24,
              shadows: AppTextStyles.shadowStyle2,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.size8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.size24),
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.deepPurpleAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
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
            return const Center(child: Text("No posts."));
          }

          return ListView.builder(
            itemCount: userPosts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final post = userPosts[index];
              return PostTileUnit(
                post: post,
                onDeletePressed: () =>
                    context.read<PostCubit>().deletePost(post.id),
              );
            },
          );
        } else if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text("Failed to load posts."));
        }
      },
    );
  }
}
