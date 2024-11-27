import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/resources/app_assets.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/date_time_util.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/widgets/multiline_text_field_unit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/comment_tile_unit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/profile_screen.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class PostTileUnit extends StatefulWidget {
  final Post post;
  final ProfileUser currentUser;
  final VoidCallback? onDeletePressed;

  const PostTileUnit({
    super.key,
    required this.post,
    required this.currentUser,
    required this.onDeletePressed,
  });

  @override
  State<PostTileUnit> createState() => _PostTileUnitState();
}

class _PostTileUnitState extends State<PostTileUnit> {
  final TextEditingController _commentTextController = TextEditingController();
  late final PostCubit _postCubit = context.read<PostCubit>();
  bool _isOwnPost = false;

  String get _appUserId => widget.currentUser.uid;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      child: Column(
        children: [
          // AUTHOR'S PROFILE HEADER
          _buildPostHeader(),
          // DISPLAY POST IMAGE
          _buildPostImage(),
          // INTERACTION BUTTONS : LIKE, COMMENT, TIMESTAMP
          _buildActionButtons(),
          // POST CAPTION
          _buildCaption(),
          // DIVIDER : SHORT
          if (widget.post.comments.isNotEmpty) _buildDivider(false),
          // COMMENT SECTION
          _buildCommentSection(),
          // DIVIDER : LONG
          _buildDivider(true),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }

  // Fetch the current logged-in user
  void _fetchCurrentUser() {
    _isOwnPost = (widget.post.userId == _appUserId);
  }

  // Handle the logic for liking/unliking a post
  void _toggleLikePost() {
    final isLiked = widget.post.likes.contains(_appUserId);

    // Optimistically update the UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(_appUserId);
      } else {
        widget.post.likes.add(_appUserId);
      }
    });

    // Update like status in the backend
    _postCubit
        .toggleLikePost(postId: widget.post.id, userId: _appUserId)
        .catchError((error) {
      setState(() {
        ToastMessengerUnit.showErrorToast(
            context: context, message: error.toString());
        // Revert like/unlike
        if (isLiked) {
          widget.post.likes.add(_appUserId);
        } else {
          widget.post.likes.remove(_appUserId);
        }
      });
    });
  }

  // Opens the comment input dialog
  void _openCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.addNewComment),
        content: MultilineTextFieldUnit(
          controller: _commentTextController,
          hintText: AppStrings.typeComment,
          labelText: AppStrings.addComment,
          maxLength: MAX_LENGTH_COMMENTS_FIELD,
        ),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text(AppStrings.cancel),
          ),
          // SAVE/SUBMIT BUTTON
          TextButton(
            onPressed: () {
              _addNewComment();
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  // Handle the logic for adding comment to the post
  void _addNewComment() {
    final comment = _commentTextController.text.trim();
    if (comment.isEmpty) {
      ToastMessengerUnit.showErrorToast(context: context, message: '');
      return;
    }

    final newComment = Comment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: _appUserId,
      userName: widget.currentUser.name,
      text: comment,
      timestamp: DateTime.now(),
    );
    _commentTextController.text = '';

    // Optimistically update the UI
    setState(() {
      widget.post.comments.add(newComment);
    });

    _postCubit
        .addComment(postId: widget.post.id, comment: newComment)
        .catchError((error) {
      setState(() {
        ToastMessengerUnit.showErrorToast(
            context: context, message: error.toString());
        widget.post.comments.remove(newComment);
      });
    });
  }

  // Handle the logic for deleting comment to the post
  void _deleteSelectedComment(Comment comment) {
    setState(() {
      widget.post.comments.remove(comment);
    });

    _postCubit
        .deleteComment(postId: widget.post.id, commentId: comment.id)
        .catchError((error) {
      setState(() {
        ToastMessengerUnit.showErrorToast(
            context: context, message: error.toString());
        widget.post.comments.add(comment);
      });
    });
  }

  // Show confirmation dialog for post deletion
  void _showDeleteOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppStrings.deleteThisPostMessage,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              AppStrings.cancel,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
          // CONFIRM DELETE BUTTON
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(displayUserId: widget.post.userId)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.size12,
              AppDimens.size12,
              AppDimens.size0,
              AppDimens.size12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile picture
                Material(
                  elevation: AppDimens.elevationSM2,
                  shape: const CircleBorder(),
                  color: Theme.of(context).colorScheme.outline,
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: CachedNetworkImage(
                      imageUrl: widget.post.userProfileImageUrl,
                      placeholder: (_, __) => const CircularProgressIndicator(),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.person_rounded,
                        size: AppDimens.size36,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      imageBuilder: (_, imageProvider) => Container(
                        height: AppDimens.size36,
                        width: AppDimens.size36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.size8),
                Column(
                  children: [
                    // Username
                    Text(
                      widget.post.userName.toString().trim(),
                      style: AppTextStyles.textStylePost.copyWith(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    // Time Ago text
                    Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: Text(
                        DateTimeUtil.datetimeAgo(widget.post.timestamp),
                        style: AppTextStyles.textStylePostWithNumbers.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: AppDimens.fontSizeSM12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: AppDimens.size12),
              ],
            ),
          ),
        ),
        const Spacer(),
        // Delete option if it's the user's post
        if (_isOwnPost)
          GestureDetector(
            onTap: _showDeleteOptions,
            child: SvgPicture.asset(
              ICON_SETTINGS_STYLE_1,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary,
                BlendMode.srcIn,
              ),
              width: AppDimens.size48,
              height: AppDimens.size48,
            ),
          ),
      ],
    );
  }

  Widget _buildPostImage() {
    return GestureDetector(
      onTap: () =>
          context.read<SliderCubit>().showSlider([widget.post.imageUrl], 0),
      onDoubleTap: _toggleLikePost,
      child: CachedNetworkImage(
        imageUrl: widget.post.imageUrl,
        placeholder: (context, url) => const AspectRatio(
          aspectRatio: 1.5, // or 3:2
          child: SizedBox(),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.image_not_supported_outlined,
          size: AppDimens.iconSizeXXL96,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        imageBuilder: (context, imageProvider) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Image(
                image: imageProvider,
                width: constraints.maxWidth,
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.size16,
        AppDimens.size16,
        AppDimens.size16,
        AppDimens.size8,
      ),
      child: Row(
        children: [
          // Like button
          SizedBox(
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggleLikePost,
                  child: PhysicalModel(
                    color: Colors.transparent,
                    elevation: AppDimens.elevationMD8,
                    shape: BoxShape.rectangle,
                    shadowColor:
                        Theme.of(context).colorScheme.surface.withOpacity(0.4),
                    child: SvgPicture.asset(
                      widget.post.likes.contains(_appUserId) 
                          ? AppAssets.Icons.likeHeartSolid
                          : AppAssets.Icons.likeHeartOutlined,
                      colorFilter: ColorFilter.mode(
                        (widget.post.likes.contains(_appUserId)
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary),
                        BlendMode.srcIn,
                      ),
                      width: AppDimens.size24,
                      height: AppDimens.size24,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.size4),
                // Like count
                Text(
                  widget.post.likes.length.toString(),
                  style: AppTextStyles.textStylePostWithNumbers.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.size12),
          // Comment button
          GestureDetector(
            onTap: _openCommentDialog,
            child: PhysicalModel(
              color: Colors.transparent,
              elevation: AppDimens.elevationMD8,
              shape: BoxShape.rectangle,
              shadowColor:
                  Theme.of(context).colorScheme.surface.withOpacity(0.4),
              child: SvgPicture.asset(
                widget.post.comments.isNotEmpty
                    ? ICON_COMMENT_FILLED
                    : ICON_COMMENT_BORDER,
                colorFilter: ColorFilter.mode(
                  widget.post.comments.isNotEmpty
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
                width: AppDimens.actionIconSize26,
                height: AppDimens.actionIconSize26,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.size4),
          Text(
            widget.post.comments.length.toString(),
            style: AppTextStyles.textStylePostWithNumbers.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const Spacer(),
          // Timestamp
          Text(
            DateTimeUtil.formatDate(widget.post.timestamp,
                format: DateTimeStyles.customShortDate),
            style: AppTextStyles.textStylePostWithNumbers.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.size20,
        AppDimens.size0,
        AppDimens.size20,
        AppDimens.size12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post.userName,
            style: AppTextStyles.textStylePost.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: AppDimens.fontSizeRG14,
            ),
          ),
          const SizedBox(height: AppDimens.size4),
          ConstrainedBox(
            constraints: const BoxConstraints(
                maxHeight: 100, minWidth: double.infinity), // Limit height
            child: SingleChildScrollView(
              child: Text(
                widget.post.captionText,
                style: AppTextStyles.textStylePost.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: AppDimens.fontSizeRG14,
                  letterSpacing: 0.7,
                  shadows: AppTextStyles.shadowStyle2,
                ),
                maxLines: 5,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isLongDivider) {
    return Padding(
      padding: isLongDivider
          ? const EdgeInsets.symmetric(horizontal: AppDimens.size8)
          : const EdgeInsets.only(right: 200, left: AppDimens.size8),
      child: Divider(
        height: 1,
        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
      ),
    );
  }

  Widget _buildCommentSection() {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoaded) {
          final post = state.posts.firstWhere((p) => p.id == widget.post.id);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.size4),
            child: ListView.builder(
              itemCount: post.comments.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => CommentTileUnit(
                comment: post.comments[index],
                currentAppUser: widget.currentUser,
                onDeletePressed: (comment) {
                  _deleteSelectedComment(comment);
                },
              ),
            ),
          );
        }

        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PostError) {
          return Center(child: Text(state.message));
        }

        return const Center(child: SizedBox());
      },
    );
  }
}
