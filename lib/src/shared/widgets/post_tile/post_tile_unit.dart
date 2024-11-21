import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/date_time_util.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/text_field_unit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/comment_tile_unit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/profile_screen.dart';

class PostTileUnit extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTileUnit({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTileUnit> createState() => _PostTileUnitState();
}

class _PostTileUnitState extends State<PostTileUnit> {
  // Cubits for state management
  late final PostCubit postCubit = context.read<PostCubit>();
  late final ProfileCubit profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false; // Determines if the post belongs to the current user

  AppUser? currentUser; // Stores the current logged-in user
  ProfileUser? postUser; // Stores the user who created the post

  // Text controller for handling the comment input
  final commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  // Fetch the current logged-in user
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = widget.post.userId == currentUser!.uid;
  }

  // Fetch the profile user for the post
  void fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // Handle the logic for liking/unliking a post
  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // Optimistically update the UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // Unlike
      } else {
        widget.post.likes.add(currentUser!.uid); // Like
      }
    });

    // Update like status in the backend
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); // Revert the unlike
        } else {
          widget.post.likes.remove(currentUser!.uid); // Revert the like
        }
      });
    });
  }

  // Opens a dialog for adding a new comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.addNewComment),
        content: TextFieldUnit(
          controller: commentTextController,
          hintText: AppStrings.typeComment,
          obscureText: false,
          prefixIcon: null,
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text(AppStrings.cancel),
          ),
          // Save button to submit the comment
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  // Adds a new comment to the post
  void addComment() {
    final comment = commentTextController.text;
    if (comment.isNotEmpty) {
      final newComment = Comment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: currentUser!.uid,
        userName: currentUser!.name,
        text: comment,
        timestamp: DateTime.now(),
      );
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  // Show confirmation dialog for post deletion
  void showDeleteOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteThisPostMessage),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text(AppStrings.cancel),
          ),
          // Confirm Delete button
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      child: Column(
        children: [
          // User profile header
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
                  postUser?.profileImageUrl != null
                      ? Material(
                          elevation: AppDimens.elevationSM2,
                          shape: const CircleBorder(),
                          color: Theme.of(context).colorScheme.outline,
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: CachedNetworkImage(
                              imageUrl: postUser!.profileImageUrl,
                              placeholder: (_, __) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (_, __, ___) => Icon(
                                Icons.person_rounded,
                                size: AppDimens.size36,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
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
                        )
                      : Icon(
                          Icons.person_rounded,
                          size: AppDimens.size36,
                          color: Theme.of(context).colorScheme.onSecondary,
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
                          style:
                              AppTextStyles.textStylePostWithNumbers.copyWith(
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

                  const Spacer(),
                  // Delete option if it's the user's post
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showDeleteOptions,
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
              ),
            ),
          ),

          // Post image
          GestureDetector(
            onTap: () => context
                .read<SliderCubit>()
                .showSlider([widget.post.imageUrl], 0),
            onDoubleTap: toggleLikePost,
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
          ),

          // Interaction buttons (Like, Comment, Timestamp)
          Padding(
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
                        onTap: toggleLikePost,
                        child: PhysicalModel(
                          color: Colors.transparent,
                          elevation: AppDimens.elevationMD8,
                          shape: BoxShape.rectangle,
                          shadowColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.4),
                          child: SvgPicture.asset(
                            widget.post.likes.contains(currentUser!.uid)
                                ? ICON_HEART_FILLED
                                : ICON_HEART_BORDER,
                            colorFilter: ColorFilter.mode(
                              (widget.post.likes.contains(currentUser!.uid)
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
                  onTap: openNewCommentBox,
                  child: PhysicalModel(
                    color: Colors.transparent,
                    elevation: AppDimens.elevationMD8,
                    shape: BoxShape.rectangle,
                    shadowColor:
                        Theme.of(context).colorScheme.surface.withOpacity(0.4),
                    child: SvgPicture.asset(
                      widget.post.comments.isNotEmpty
                          ? ICON_COMMENT_STYLE_1
                          : ICON_COMMENT_BORDER,
                      colorFilter: ColorFilter.mode(
                        widget.post.comments.isNotEmpty
                            ? Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.9)
                            : Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                      width: widget.post.comments.isNotEmpty ? 26 : 22,
                      height: widget.post.comments.isNotEmpty ? 26 : 22,
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
          ),

          // Caption
          Padding(
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
                      maxHeight: 100,
                      minWidth: double.infinity), // Limit height
                  child: SingleChildScrollView(
                    child: Text(
                      widget.post.text.replaceAll("\\n", "\n"),
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
          ),

          if (widget.post.comments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 200, left: AppDimens.size8),
              child: Divider(
                height: 1,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.1),
              ),
            ),

          // Comments section
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoaded) {
                final post =
                    state.posts.firstWhere((p) => p.id == widget.post.id);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppDimens.size4),
                  child: ListView.builder(
                    itemCount: post.comments.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        CommentTileUnit(comment: post.comments[index]),
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.size8),
            child: Divider(
              height: 1,
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
            ),
          )
        ],
      ),
    );
  }
}
