import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';

class EditProfileButtonUnit extends StatefulWidget {
  final VoidCallback onPressed;

  const EditProfileButtonUnit({super.key, required this.onPressed});

  @override
  State<EditProfileButtonUnit> createState() => _EditProfileButtonUnitState();
}

class _EditProfileButtonUnitState extends State<EditProfileButtonUnit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = _controller;
    _controller.reverse();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.bluePurple600,
                    AppColors.bluePurple900L1,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.editProfile,
                    style: AppStyles.buttonTextPrimary.copyWith(
                      color: AppColors.deepPurple50,
                      fontSize: AppDimens.fontSizeMD15,
                      letterSpacing: AppDimens.letterSpacingPT12,
                    ),
                  ),
                  const SizedBox(width: AppDimens.size12),
                  const Icon(
                    Icons.edit_note_sharp,
                    color: Colors.white,
                    size: AppDimens.size24,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
