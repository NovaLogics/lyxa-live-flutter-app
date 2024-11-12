import 'package:flutter/material.dart';

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
      // Padding on outside
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          padding: const EdgeInsets.all(12),
          onPressed: onPressed,
          color: isFollowing
              ? Theme.of(context).colorScheme.inversePrimary
              : Colors.blueAccent,
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
