import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/constants/assets/app_fonts.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/profile/cubits/self_profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/cubits/self_profile_state.dart';
import 'package:lyxa_live/src/features/profile/data/services/profile_service.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/features/profile/ui/components/edit_profile_button_unit.dart';
import 'package:lyxa_live/src/features/profile/ui/components/profile_image.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/post_tile_unit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/profile/ui/components/story_line_unit.dart';
import 'package:lyxa_live/src/features/profile/ui/components/profile_stats_unit.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/edit_profile_screen.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/follower_screen.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

class SelfProfileScreen extends StatefulWidget {
  const SelfProfileScreen({super.key});

  @override
  State<SelfProfileScreen> createState() => _SelfProfileScreenState();
}

class _SelfProfileScreenState extends State<SelfProfileScreen> {
 // late final SelfProfileCubit _selfprofileCubit;
  late final ProfileService _profileService;

  get _appUserId => _profileService.getUserId();

  @override
  void initState() {
    super.initState();
    _initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelfProfileCubit, SelfProfileState>(
      builder: (context, state) {
        if (state is SelfProfileLoaded) {
          return _buildProfileContent(
            context,
            state.profileUser,
          );
        } else if (state is SelfProfileError) {
          return _buildEmptyContent(
            displayText: AppStrings.profileNotFoundError,
          );
        } else {
          return _buildEmptyContent();
        }
      },
    );
  }

  void _initScreen() async {
    _profileService = getIt<ProfileService>();
 //   _selfprofileCubit = getIt<SelfProfileCubit>();
  }

  Widget _buildProfileContent(BuildContext context, ProfileUserEntity user) {
    Logger.logDebug('$_appUserId ');
    _profileService.syncProfile(user);

    return ConstrainedScaffold(
      appBar: _buildAppBar(context, user),
      body: ListView(
        children: [
          addSpacing(height: AppDimens.size8),
          _buildProfilePicture(user),
          addSpacing(height: AppDimens.size8),
          _buildUserNameSection(user),
          _buildEmailSection(user),
          addSpacing(height: AppDimens.size8),
          _buildProfileStats(user),
          addSpacing(height: AppDimens.size12),
          _buildStoryLineSection(user.bio),
          addSpacing(height: AppDimens.size24),
          _buildEditProfileSection(),
          addSpacing(height: AppDimens.size24),
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

  AppBar _buildAppBar(BuildContext context, ProfileUserEntity user) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      title: Center(
        child: Text(
          AppStrings.profile,
          style: AppStyles.textAppBarStatic.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            letterSpacing: AppDimens.letterSpacingPT10,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.elMessiri,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(ProfileUserEntity user) {
    return SizedBox(
      height: AppDimens.size128,
      child: ProfileImage(
        imageUrl: user.profileImageUrl,
      ),
    );
  }

  Widget _buildUserNameSection(ProfileUserEntity user) {
    return Center(
      child: Text(
        user.name,
        style: AppStyles.textSubtitlePost.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: AppDimens.fontSizeXL20,
          letterSpacing: AppDimens.letterSpacingPT05,
        ),
      ),
    );
  }

  Widget _buildEmailSection(ProfileUserEntity user) {
    return Center(
      child: Text(
        user.email,
        style: AppStyles.subtitleRegular.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: AppDimens.fontSizeMD16,
          fontWeight: FontWeight.w600,
          shadows: AppStyles.shadowStyleEmpty,
        ),
      ),
    );
  }

  Widget _buildProfileStats(ProfileUserEntity displayUser) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        int postCount = (state is PostLoaded)
            ? state.posts.where((post) => post.userId == _appUserId).length
            : 0;

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

  Widget _buildStoryLineSection(String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.size32),
          child: Text(
            AppStrings.storylineDecoText,
            style: AppStyles.subtitleSecondary.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
              shadows: AppStyles.shadowStyleEmpty,
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

  Widget _buildEditProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.size32),
      child: EditProfileButtonUnit(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  EditProfileScreen(currentUser: _profileService.profileEntity),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostSection(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoaded) {
          final userPosts =
              state.posts.where((post) => post.userId == _appUserId).toList();

          if (userPosts.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.size12,
                vertical: AppDimens.size64,
              ),
              child: Center(
                child: Text(
                  AppStrings.noPosts,
                  style: AppStyles.textMessageStatic.copyWith(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: userPosts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final post = userPosts[index];
              return PostTileUnit(
                post: post,
                currentUser: _profileService.profileEntity,
                onDeletePressed: () =>
                    getIt<PostCubit>().deletePost(post: post),
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
