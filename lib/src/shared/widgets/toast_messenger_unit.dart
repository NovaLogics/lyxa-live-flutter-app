import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';

///USAGE ->
//  ToastMessengerUnit.showToast(
//     context: context,
//     message: "This is a custom toast message!",
//     icon: Icons.check_circle,
//     backgroundColor: AppColors.deepPurpleShade800,
//     textColor: Colors.white,
//     shadowColor: Colors.black,
//     buttonText: "Undo",
//     onButtonPressed: () {
//       print("Button Pressed!");
//     },
//     duration: const Duration(seconds: 5), // Customize how long to show
//   );

class ToastMessengerUnit {
  static OverlayEntry? _overlayEntry;
  static Timer? _toastTimer;

  /// Show a custom toast message
  /// [message] - Text to display
  /// [context] - BuildContext required to show overlay
  /// [icon] - Icon to display alongside the text
  /// [backgroundColor] - Background color of the toast
  /// [textColor] - Text color
  /// [shadowColor] - Shadow color of the toast
  /// [buttonText] - Optional button text
  /// [onButtonPressed] - Optional button action
  /// [duration] - How long to display the toast
  static void showToast({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    Color shadowColor = Colors.grey,
    String? buttonText,
    VoidCallback? onButtonPressed,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Remove any existing toast
    _removeToast();

    // Create overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        const toastWidth = 360.0; // Adjust this based on your desired width
        return Positioned(
          bottom: 50, // Distance from the bottom
          left: (screenWidth - toastWidth) / 2, // Center horizontally
          width: toastWidth, // Set the width of the toast
          child: _buildToastWidget(
            message: message,
            icon: icon,
            backgroundColor: backgroundColor,
            textColor: textColor,
            shadowColor: shadowColor,
            buttonText: buttonText,
            onButtonPressed: onButtonPressed,
          ),
        );
      },
    );

    // Insert the overlay entry
    Overlay.of(context).insert(_overlayEntry!);

    // Set a timer to remove the toast
    _toastTimer = Timer(duration, () => _removeToast());
  }

  static Widget _buildToastWidget({
    required String message,
    IconData? icon,
    required Color backgroundColor,
    required Color textColor,
    required Color shadowColor,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.5),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: textColor,
                size: 24,
              ),
            if (icon != null) const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: FONT_RALEWAY,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static void _removeToast() {
    _toastTimer?.cancel();
    _toastTimer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
