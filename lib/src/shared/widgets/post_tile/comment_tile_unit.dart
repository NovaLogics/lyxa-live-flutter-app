import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';

class CommentTileUnit extends StatefulWidget {
  final AppUser currentAppUser;
  final Comment comment;
  final Function(Comment) onDeletePressed;

  const CommentTileUnit({
    super.key,
    required this.comment,
    required this.currentAppUser,
    required this.onDeletePressed,
  });

  @override
  State<CommentTileUnit> createState() => _CommentTileUnitState();
}

class _CommentTileUnitState extends State<CommentTileUnit> {
  bool _isOwnPost = false;

  String get _appUserId => widget.currentAppUser.uid;

  @override
  void initState() {
    super.initState();
    _initValues();
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
            "⤷ ${widget.comment.userName} ⬪",
            style: AppStyles.textSubtitlePost.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: AppDimens.fontSizeSM13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppDimens.size8),

          // COMMENT TEXT
          Flexible(
            child: SizedBox(
              width: AppDimens.containerSize430,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: AppDimens.size100,
                ),
                child: Text(
                  widget.comment.text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: AppDimens.fontSizeSM13,
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
          (_isOwnPost)
              ? GestureDetector(
                  onTap: _showOptions,
                  child: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: AppDimens.iconSizeSM20,
                  ),
                )
              : const SizedBox(
                  height: AppDimens.iconSizeSM20,
                ),
        ],
      ),
    );
  }

  void _initValues() {
    _isOwnPost = (widget.comment.userId == _appUserId);
  }

  // Show options for deletion
  void _showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        title: Text(
          AppStrings.deleteCommentMessage,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
        ),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(AppStrings.dialog);
            },
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface),
            ),
          ),
          // DELETE BUTTON
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(AppStrings.dialog);
              widget.onDeletePressed(widget.comment).call();
            },
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
