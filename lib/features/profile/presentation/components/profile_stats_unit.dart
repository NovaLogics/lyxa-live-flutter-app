import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  postCount.toString(),
                  style: textStyleForCount,
                ),
                Text(
                  "Posts",
                  style: textStyleForText,
                ),
              ],
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
