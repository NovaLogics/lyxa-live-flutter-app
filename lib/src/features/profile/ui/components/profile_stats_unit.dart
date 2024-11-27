import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';

class ProfileStatsUnit extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStatsUnit({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

// Build UI
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Post
          Container(
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    //Posts
                    SizedBox(
                      width: 104,
                      child: Column(
                        children: [
                          Text(
                            postCount.toString(),
                            style: AppStyles.textNumberStyle1.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                          const SizedBox(height: AppDimens.size4),
                          Text(
                            AppStrings.postsUpperCase,
                            style: AppStyles.textSubtitlePost.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Followers
                    SizedBox(
                      width: 104,
                      child: Column(
                        children: [
                          Text(
                            followerCount.toString(),
                            style: AppStyles.textNumberStyle1.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                          const SizedBox(height: AppDimens.size4),
                          Text(
                            AppStrings.followersUpperCase,
                            style: AppStyles.textSubtitlePost.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Following
                    SizedBox(
                      width: 104,
                      child: Column(
                        children: [
                          Text(
                            followingCount.toString(),
                            style: AppStyles.textNumberStyle1.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                          const SizedBox(height: AppDimens.size4),
                          Text(
                            AppStrings.followingUpperCase,
                            style: AppStyles.textSubtitlePost.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
