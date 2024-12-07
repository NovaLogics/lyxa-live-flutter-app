import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/constants/assets/app_fonts.dart';
import 'package:lyxa_live/src/core/constants/assets/app_icons.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/validations/text_field_limits.dart';
import 'package:lyxa_live/src/core/utils/date_time_util.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/shared/widgets/multiline_text_field_unit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment_entity.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/comment_tile_unit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/profile_screen.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class PostTileUnit extends StatefulWidget {
  final PostEntity post;
  final ProfileUserEntity currentUser;
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
      color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
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
          // labelText: AppStrings.addComment,
          maxLength: TextFieldLimits.commentsField,
          autofocus: true,
        ),
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
          // SAVE/SUBMIT BUTTON
          TextButton(
            onPressed: () {
              _addNewComment();
              Navigator.of(context).pop();
            },
            child: Text(
              AppStrings.save,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
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

    final newComment = CommentEntity(
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
  void _deleteSelectedComment(CommentEntity comment) {
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
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        title: Text(
          AppStrings.deleteThisPostMessage,
          style:
              TextStyle(color: Theme.of(context).colorScheme.onInverseSurface),
        ),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              FocusScope.of(context).unfocus();
            },
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface),
            ),
          ),
          // CONFIRM DELETE BUTTON
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
              FocusScope.of(context).unfocus();
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

  Widget _createProfileImage() {
    return Material(
      elevation: AppDimens.elevationSM2,
      borderRadius: BorderRadius.circular(24.0),
      color: Theme.of(context).colorScheme.outline,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Image.network(
            widget.post.userProfileImageUrl,
            fit: BoxFit.cover,
            height: AppDimens.size36,
            width: AppDimens.size36,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                height: AppDimens.size36,
                width: AppDimens.size36,
                child: const Icon(Icons.person, color: Colors.grey),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Container(
                  height: AppDimens.size36,
                  width: AppDimens.size36,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    _fetchCurrentUser();
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
                _createProfileImage(),
                // Material(
                //   elevation: AppDimens.elevationSM2,
                //   shape: const CircleBorder(),
                //   color: Theme.of(context).colorScheme.outline,
                //   child: Padding(
                //     padding: const EdgeInsets.all(1),
                //     child: CachedNetworkImage(
                //       imageUrl: widget.post.userProfileImageUrl,
                //       placeholder: (_, __) => const CircularProgressIndicator(),
                //       errorWidget: (_, __, ___) => Icon(
                //         Icons.person_rounded,
                //         size: AppDimens.size36,
                //         color: Theme.of(context).colorScheme.onSecondary,
                //       ),
                //       imageBuilder: (_, imageProvider) => Container(
                //         height: AppDimens.size36,
                //         width: AppDimens.size36,
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           image: DecorationImage(
                //             image: imageProvider,
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(width: AppDimens.size8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username
                    Text(
                      widget.post.userName.toString().trim(),
                      style: AppStyles.textTitlePost.copyWith(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    // Time Ago text

                    Padding(
                      padding: const EdgeInsets.only(left: AppDimens.size2),
                      child: Text(
                        DateTimeUtil.datetimeAgo(widget.post.timestamp).trim(),
                        style: AppStyles.textNumberStyle2.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: AppDimens.fontSizeSM12,
                          letterSpacing: AppDimens.letterSpacingPT01,
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
          IconButton(
            onPressed: _showDeleteOptions,
            icon: _getDeleteIcon(),
            tooltip: AppStrings.removeThisPost,
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
        kIsWeb ? AppDimens.size16 : AppDimens.size0,
        AppDimens.size16,
        kIsWeb ? AppDimens.size16 : AppDimens.size0,
      ),
      child: Row(
        children: [
          // Like button
          Row(
            children: [
              SizedBox(
                width: AppDimens.size32,
                child: IconButton(
                  onPressed: _toggleLikePost,
                  icon: _getLikeHeartIcon(),
                  tooltip: AppStrings.likeThisPost,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ),
              // Like count
              Text(
                widget.post.likes.length.toString(),
                style: AppStyles.textNumberStyle2.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(width: AppDimens.size12),
          // Comment button
          SizedBox(
            width: AppDimens.size28,
            child: IconButton(
              onPressed: _openCommentDialog,
              icon: _getCommentIcon(),
              tooltip: AppStrings.postAComment,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(width: AppDimens.size4),
          Text(
            widget.post.comments.length.toString(),
            style: AppStyles.textNumberStyle2.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const Spacer(),
          // Timestamp
          Text(
            DateTimeUtil.formatDate(widget.post.timestamp,
                format: DateTimeStyles.customShortDate),
            style: AppStyles.textNumberStyle2.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDeleteIcon() {
    final colour = Theme.of(context).colorScheme.primary;
    return kIsWeb
        ? Icon(
            Icons.more_vert_rounded,
            color: colour,
          )
        : SvgPicture.asset(
            AppIcons.settingsOutlinedStyle1,
            colorFilter: ColorFilter.mode(
              colour,
              BlendMode.srcIn,
            ),
            width: AppDimens.size48,
            height: AppDimens.size48,
          );
  }

  Widget _getLikeHeartIcon() {
    final isAlreadyLiked = (widget.post.likes.contains(_appUserId));
    final colour = isAlreadyLiked
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onPrimary;

    return kIsWeb
        ? Icon(
            isAlreadyLiked ? Icons.favorite : Icons.favorite_border,
            color: colour,
          )
        : SvgPicture.asset(
            isAlreadyLiked
                ? AppIcons.likeHeartSolid
                : AppIcons.likeHeartOutlined,
            colorFilter: ColorFilter.mode(
              colour,
              BlendMode.srcIn,
            ),
            width: AppDimens.size24,
            height: AppDimens.size24,
          );
  }

  Widget _getCommentIcon() {
    final hasComments = (widget.post.comments.isNotEmpty);
    final colour = hasComments
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onPrimary;

    return kIsWeb
        ? Icon(
            hasComments
                ? Icons.insert_comment_rounded
                : Icons.mode_comment_outlined,
            color: colour,
          )
        : SvgPicture.asset(
            hasComments ? AppIcons.commentSolid : AppIcons.commentOutlined,
            colorFilter: ColorFilter.mode(
              colour,
              BlendMode.srcIn,
            ),
            width: AppDimens.actionIconSize26,
            height: AppDimens.actionIconSize26,
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
            style: AppStyles.textTitlePost.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.size4),
          ConstrainedBox(
            constraints:
                const BoxConstraints(maxHeight: 300, minWidth: double.infinity),
            child: SingleChildScrollView(
              child: Text.rich(
                TextSpan(
                  children: _buildStyledText(widget.post.captionText, context),
                ),
                maxLines: 16,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildStyledText(String text, BuildContext context) {
    text = text.replaceAll('\n#', '\n #');
    text = text.replaceAll('\n@', '\n @');
    final words = text.split(' ');
    final List<TextSpan> spans = [];

    for (final word in words) {
      if (word.startsWith('#')) {
        spans.add(
          TextSpan(
            text: '$word ',
            style: AppStyles.textTitlePost.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.raleway,
              letterSpacing: AppDimens.letterSpacingPT07,
            ),
          ),
        );
      } else if (word.startsWith('@')) {
        spans.add(
          TextSpan(
            text: '$word ',
            style: AppStyles.textTitlePost.copyWith(
              color: AppColors.teal700,
              fontWeight: FontWeight.w500,
              fontSize: AppDimens.fontSizeMD17,
              fontFamily: AppFonts.balooPaaji2,
              letterSpacing: -0.1,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word ',
            style: AppStyles.textTitlePost.copyWith(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        );
      }
    }

    return spans;
  }

  Widget _buildDivider(bool isLongDivider) {
    return Padding(
      padding: isLongDivider
          ? const EdgeInsets.symmetric(horizontal: AppDimens.size8)
          : const EdgeInsets.only(right: 200, left: AppDimens.size8),
      child: Divider(
        height: 4,
        color: Theme.of(context)
            .colorScheme
            .inversePrimary
            .withOpacity(isLongDivider ? 0.3 : 0.2),
      ),
    );
  }

  Widget _buildCommentSection() {
    final post = widget.post;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.size4),
      child: Column(
        children: post.comments.map((comment) {
          return CommentTileUnit(
            comment: comment,
            currentAppUser: widget.currentUser,
            onDeletePressed: (comment) {
              _deleteSelectedComment(comment);
            },
          );
        }).toList(),
      ),
    );

    // return SizedBox(
    //   width: 300,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: AppDimens.size4),
    //     child: ListView.builder(
    //       itemCount: post.comments.length,
    //       shrinkWrap: true,
    //       physics: const NeverScrollableScrollPhysics(),
    //       itemBuilder: (context, index) => CommentTileUnit(
    //         comment: post.comments[index],
    //         currentAppUser: widget.currentUser,
    //         onDeletePressed: (comment) {
    //           _deleteSelectedComment(comment);
    //         },
    //       ),
    //     ),
    //   ),
    // );

    // return BlocBuilder<PostCubit, PostState>(
    //   builder: (context, state) {
    //     if (state is PostLoaded) {
    //       final post = state.posts.firstWhere((post) => post.id == widget.post.id);
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(vertical: AppDimens.size4),
    //         child: ListView.builder(
    //           itemCount: post.comments.length,
    //           shrinkWrap: true,
    //           physics: const NeverScrollableScrollPhysics(),
    //           itemBuilder: (context, index) => CommentTileUnit(
    //             comment: post.comments[index],
    //             currentAppUser: widget.currentUser,
    //             onDeletePressed: (comment) {
    //               _deleteSelectedComment(comment);
    //             },
    //           ),
    //         ),
    //       );
    //     }

    //     if (state is PostLoading) {
    //       return const Center(child: CircularProgressIndicator());
    //     }

    //     if (state is PostError) {
    //       return Center(child: Text(state.message));
    //     }

    //     return const SizedBox();
    //   },
    // );
  }
}
