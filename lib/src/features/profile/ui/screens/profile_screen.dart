import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/ui/components/profile_image.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/loading_unit.dart';
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
  late final ProfileCubit _profileCubit;
  ProfileUser _currentAppUser = ProfileUser.getGuestUser();

  get _appUserId => _currentAppUser.uid;

  get _displayUserId => widget.displayUserId;

  @override
  void initState() {
    super.initState();
    _profileCubit = getIt<ProfileCubit>();
    _fetchUserProfile(_displayUserId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Stack(
          children: [
            if (state is ProfileLoaded)
              _buildProfileContent(
                context,
                state.profileUser,
              ),
            if (state is! ProfileLoaded)
              _buildEmptyContent(
                displayText: AppStrings.profileNotFoundError,
              ),
            _buildLoadingScreen(),
          ],
        );
      },
    );
  }

  void _fetchUserProfile(String profileUserId) async {
    _currentAppUser = await _profileCubit.getCurrentUser();

    _profileCubit.loadUserProfileById(userId: profileUserId);
  }

  void _handleFollowButtonPressed() {
    final profileState = _profileCubit.state;

    if (profileState is! ProfileLoaded) return;

    final profileUser = profileState.profileUser;
    final isAlreadyFollowing = profileUser.followers.contains(_appUserId);

    setState(() {
      isAlreadyFollowing
          ? profileUser.followers.remove(_appUserId)
          : profileUser.followers.add(_appUserId);
    });

    _profileCubit
        .toggleFollow(appUserId: _appUserId, targetUserId: _displayUserId)
        .catchError((_) {
      setState(() {
        isAlreadyFollowing
            ? profileUser.followers.add(_appUserId)
            : profileUser.followers.remove(_appUserId);
      });
    });
  }

  Widget _buildLoadingScreen() {
    return BlocConsumer<LoadingCubit, LoadingState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Visibility(
          visible: state.isVisible,
          child: LoadingUnit(
            message: state.message,
          ),
        );
      },
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileUser user) {
    final isOwnProfile = (_displayUserId == _appUserId);
    Logger.logDebug('$isOwnProfile  $_displayUserId = $_appUserId ');

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

  Widget _buildEmptyContent({String? displayText = ''}) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text(displayText ?? ''),
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
      actions: [
        isOwnProfile
            ? IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(currentUser: user),
                  ),
                ),
                icon: const Icon(Icons.settings_outlined),
                iconSize: AppDimens.iconSizeSM24,
              )
            : const SizedBox(width: AppDimens.iconSizeMD32),
      ],
    );
  }

  Widget _buildProfilePicture(ProfileUser user) {
    return ProfileImage(
      imageUrl: user.profileImageUrl,
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

  Widget _buildProfileStats(ProfileUser displayUser) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        int postCount = 0;

        if (state is PostLoaded) {
          postCount =
              state.posts.where((post) => post.userId == _displayUserId).length;
        }

        return Padding(
          padding: const EdgeInsets.all(AppDimens.paddingRG8),
          child: ProfileStatsUnit(
            postCount: postCount,
            followerCount: displayUser.followers.length,
            followingCount: displayUser.following.length,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FollowerScreen(
                  followers: displayUser.followers,
                  following: displayUser.following,
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
      isFollowing: user.followers.contains(_appUserId),
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
                currentUser: _currentAppUser,
                onDeletePressed: () =>
                    context.read<PostCubit>().deletePost(postId: post.id),
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
