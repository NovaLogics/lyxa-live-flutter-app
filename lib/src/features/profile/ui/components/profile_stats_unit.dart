import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';

class ProfileStatsUnit extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final VoidCallback? onTap;

  const ProfileStatsUnit({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
            borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.paddingRG8),
              child: Row(
                children: [
                  //Post Count
                  _buildDisplayUnit(
                    context,
                    count: postCount.toString(),
                    label: AppStrings.postsUpperCase,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          // Followers
                          _buildDisplayUnit(
                            context,
                            count: followerCount.toString(),
                            label: AppStrings.followersUpperCase,
                          ),
                          // Following
                          _buildDisplayUnit(
                            context,
                            count: followingCount.toString(),
                            label: AppStrings.followingUpperCase,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildDisplayUnit(
  BuildContext context, {
  required String count,
  required String label,
}) {
  return SizedBox(
    width: 104,
    child: Column(
      children: [
        Text(
          count,
          style: AppStyles.textNumberStyle1.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        addSpacing(height: AppDimens.size4),
        Text(
          label,
          style: AppStyles.textSubtitlePost.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            letterSpacing: AppDimens.letterSpacingPT05,
          ),
        ),
      ],
    ),
  );
}
