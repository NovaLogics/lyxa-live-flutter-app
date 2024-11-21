import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
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
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingLG20, vertical: AppDimens.paddingXS2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // USERNAME
          Text(
            "⤷ ${widget.comment.userName}",
            style: AppTextStyles.textStylePost.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
              fontSize: AppDimens.fontSizeSM12,
            ),
          ),
          const SizedBox(width: AppDimens.size12),

          // COMMENT TEXT
          SizedBox(
            width: AppDimens.size220,
            child: Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: AppDimens.size100,
                ),
                child: Text(
                  widget.comment.text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: AppDimens.fontSizeSM12,
                    fontWeight: FontWeight.normal,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
            ),
          ),

          const Spacer(),

          // DELETE BUTTON
          if (isOwnPost)
            GestureDetector(
              onTap: _showOptions,
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
        ],
      ),
    );
  }

  void _fetchCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  // Show options for deletion
  void _showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteCommentMessage),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(AppStrings.dialog);
            },
            child: const Text(AppStrings.cancel),
          ),
          // DELETE BUTTON
          TextButton(
            onPressed: () {
              context.read<PostCubit>().deleteComment(
                    widget.comment.postId,
                    widget.comment.id,
                  );
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}
