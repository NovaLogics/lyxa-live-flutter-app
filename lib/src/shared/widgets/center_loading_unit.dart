import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';

class CenterLoadingUnit extends StatelessWidget {
  final String message;

  const CenterLoadingUnit({super.key, this.message = "Please wait..."});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Card(
          color: const Color(0xFFEEEEEE), // Background semi-transparent
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(54.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: Colors.deepPurple,
                ), // Loading indicator
                const SizedBox(height: 24.0),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 20,
                    letterSpacing: 1.1,
                    fontFamily: FONT_RALEWAY,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4527A0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
