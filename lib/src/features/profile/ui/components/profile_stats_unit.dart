import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';

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
    var textStyleForCount = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
      fontWeight: FontWeight.normal,
      fontSize: 20,
    );

    var textStyleForText = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.normal,
      fontSize: 16,
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Post
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface, // Background color
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .onSecondary
                      .withOpacity(0.2), // Shadow color
                  blurRadius: 2.0, // Blur radius
                  offset: const Offset(0.5, 0.5), // Offset for the shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0), // Inner padding
              child: SizedBox(
                width: 100,
                child: Column(
                  children: [
                    Text(
                      postCount.toString(),
                      style: AppTextStyles.textStylePostWithNumbers.copyWith(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimens.textSizeMedium,
                      ),
                    ),
                    Text(
                      AppStrings.postsUpperCase,
                      style: AppTextStyles.textStylePost.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Followers
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followerCount.toString(),
                  style: textStyleForCount,
                ),
                Text(
                  "Followers",
                  style: textStyleForText,
                ),
              ],
            ),
          ),

          // Following
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followingCount.toString(),
                  style: textStyleForCount,
                ),
                Text(
                  "Following",
                  style: textStyleForText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
