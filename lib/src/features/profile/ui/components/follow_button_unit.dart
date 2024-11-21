import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';

class FollowButtonUnit extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButtonUnit({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  // Build UI
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
                        AppColors.deepPurpleShade900,
                        AppColors.bluePurpleShade300,
                      ],
                    )
                  : const LinearGradient(
                      colors: [
                        AppColors.deepPurpleShade700,
                        AppColors.deepPurpleShade300,
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
                  color: AppColors.deepPurpleShade50,
                  fontSize: AppDimens.fontSizeRg14,
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
