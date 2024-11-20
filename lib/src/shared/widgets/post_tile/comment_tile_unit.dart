import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';

class CommentTileUnit extends StatefulWidget {
  final Comment comment;

  const CommentTileUnit({
    super.key,
    required this.comment,
  });

  @override
  State<CommentTileUnit> createState() => _CommentTileUnitState();
}

class _CommentTileUnitState extends State<CommentTileUnit> {
  // Current user
  AppUser? currentUser;
  bool isOwnPost = false;

  // On startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  // Show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Comment"),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: const Text("Cancel"),
          ),
          // Delete button
          TextButton(
            onPressed: () {
              context.read<PostCubit>().deleteComment(
                    widget.comment.postId,
                    widget.comment.id,
                  );
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
        children: [
          // Username
          Text(
            "⤷ ${widget.comment.userName}",
            style: AppTextStyles.textStylePost.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
              fontSize: AppDimens.textSizeSmall,
            ),
          ),
          const SizedBox(width: 10),

          // Comment Text
          SizedBox(
            width: 220,
            child: Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                ),
                child: Text(
                  widget.comment.text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  softWrap: true, // Wrap long text
                  overflow: TextOverflow.ellipsis, // Show ellipsis for overflow
                  maxLines: 5, // Limit to 5 lines
                ),
              ),
            ),
          ),

          const Spacer(),

          // Delete Button
          if (isOwnPost)
            GestureDetector(
              onTap: showOptions,
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
