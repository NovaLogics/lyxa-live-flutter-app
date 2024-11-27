import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';

class FollowButtonUnit extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButtonUnit({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0), // Padding outside
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18), // Rounded corners
        child: GestureDetector(
          onTap: onPressed, // Button action
          child: Container(
            decoration: BoxDecoration(
              gradient: isFollowing
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
                    ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12), // Inner padding
            child: Center(
              child: Text(
                isFollowing
                    ? AppStrings.unfollowUpperCase
                    : AppStrings.followUpperCase,
                style: AppTextStyles.buttonTextPrimary.copyWith(
                  color: AppColors.deepPurple50,
                  fontSize: AppDimens.fontSizeRG14,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
