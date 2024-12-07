import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';

class FollowButtonUnit extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isFollowing;

  const FollowButtonUnit({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.size32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusLG16),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              gradient: _getLinearGradient(isFollowing),
              borderRadius: BorderRadius.circular(AppDimens.radiusLG16),
            ),
            padding: const EdgeInsets.all(AppDimens.size12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isFollowing
                      ? AppStrings.unfollowUpperCase
                      : AppStrings.followUpperCase,
                  style: AppStyles.buttonTextPrimary.copyWith(
                    color: AppColors.deepPurple50,
                    fontSize: AppDimens.fontSizeRG14,
                    letterSpacing: AppDimens.letterSpacingPT12,
                  ),
                ),
                const SizedBox(width: AppDimens.size12),
                Icon(
                  isFollowing
                      ? Icons.group_remove_outlined
                      : Icons.group_add_outlined,
                  color: Colors.white,
                  size: AppDimens.size20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

LinearGradient _getLinearGradient(bool isFollowing) {
  return isFollowing
      ? const LinearGradient(
          colors: [
            AppColors.deepPurple900,
            AppColors.bluePurple300,
          ],
        )
      : const LinearGradient(
          colors: [
            AppColors.deepPurple700,
            AppColors.deepPurple300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
}
