import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/post_tile_unit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/profile/ui/components/bio_box_unit.dart';
import 'package:lyxa_live/src/features/profile/ui/components/follow_button_unit.dart';
import 'package:lyxa_live/src/features/profile/ui/components/profile_stats_unit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_state.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/edit_profile_screen.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/follower_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthCubit _authCubit;
  late final ProfileCubit _profileCubit;
  late AppUser? _currentUser;

  @override
  void initState() {
    super.initState();

    _authCubit = context.read<AuthCubit>();
    _profileCubit = context.read<ProfileCubit>();
    _currentUser = _authCubit.currentUser;

    // Fetch user profile data
    _profileCubit.fetchUserProfile(widget.uid);
  }

  /// Handles the follow/unfollow button press.
  void _handleFollowButtonPressed() {
    final profileState = _profileCubit.state;

    if (profileState is! ProfileLoaded) return;

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(_currentUser!.uid);

    // Optimistically update UI
    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(_currentUser!.uid);
      } else {
        profileUser.followers.add(_currentUser!.uid);
      }
    });

    // Perform follow/unfollow logic and handle errors
    _profileCubit.toggleFollow(_currentUser!.uid, widget.uid).catchError((_) {
      // Revert optimistic UI changes if the operation fails
      setState(() {
        if (isFollowing) {
          profileUser.followers.add(_currentUser!.uid);
        } else {
          profileUser.followers.remove(_currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOwnProfile = widget.uid == _currentUser!.uid;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return _buildProfileContent(context, state.profileUser, isOwnProfile);
        } else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text("Profile not found.")),
          );
        }
      },
    );
  }

  Widget _buildProfileContent(
      BuildContext context, ProfileUser user, bool isOwnProfile) {
    return Scaffold(
      appBar: _buildAppBar(context, user, isOwnProfile),
      body: ListView(
        children: [
          _buildProfileHeader(user),
          _buildProfileStats(user),
          if (!isOwnProfile)
            FollowButtonUnit(
              onPressed: _handleFollowButtonPressed,
              isFollowing: user.followers.contains(_currentUser!.uid),
            ),
          const SizedBox(height: 25),
          _buildBioSection(user.bio),
          const SizedBox(height: 25),
          _buildPostSection(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, ProfileUser user, bool isOwnProfile) {
    return AppBar(
      title: Center(child: Text(user.name)),
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
                icon: const Icon(Icons.settings),
              ),
            ]
          : null,
    );
  }

  Widget _buildProfileHeader(ProfileUser user) {
    return Column(
      children: [
        Material(
          elevation: 2.0,
          shape: const CircleBorder(),
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CachedNetworkImage(
              imageUrl: user.profileImageUrl,
              placeholder: (_, __) => const CircularProgressIndicator(),
              errorWidget: (_, __, ___) => Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              imageBuilder: (_, imageProvider) => Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          user.email,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildProfileStats(ProfileUser user) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        int postCount = 0;

        if (state is PostLoaded) {
          postCount =
              state.posts.where((post) => post.userId == widget.uid).length;
        }

        return ProfileStatsUnit(
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
        );
      },
    );
  }

  Widget _buildBioSection(String bio) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bio',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 12),
          BioBoxUnit(text: bio),
        ],
      ),
    );
  }

  Widget _buildPostSection(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoaded) {
          final userPosts =
              state.posts.where((post) => post.userId == widget.uid).toList();

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
