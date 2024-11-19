import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/utils/helper/date_time_util.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/shared/widgets/custom_toast.dart';
import 'package:lyxa_live/src/features/slider_images/ui/slider_full_images.dart';
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
        title: const Text("Add a new comment"),
        content: TextFieldUnit(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
          prefixIcon: null,
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("Cancel"),
          ),
          // Save button to submit the comment
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
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
        title: const Text("Delete this post?"),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("Cancel"),
          ),
          // Confirm Delete button
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
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
    return Container(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      child: Column(
        children: [
          // User profile header
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(uid: widget.post.userId)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile picture
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl,
                          errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                          errorListener: (value) => CustomToast.showToast(
                            context: context,
                            message: "Error loading image..",
                            icon: Icons.check_circle,
                            backgroundColor: AppColors.deepPurpleShade900,
                            textColor: Colors.white,
                            shadowColor: Colors.black,
                            duration: const Duration(seconds: 4),
                          ),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
                          ),
                        )
                      : const Icon(Icons.person),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      // User name
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
                          DateTimeUtil.datetimeAgo(
                            widget.post.timestamp,
                          ),
                          style:
                              AppTextStyles.textStylePostWithNumbers.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: AppDimens.textSizeSmall,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  const Spacer(),
                  // Delete option if it's the user's post
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showDeleteOptions,
                      child: SvgPicture.asset(
                        'assets/icons/ic_settings_style_1.svg',
                        color: Theme.of(context).colorScheme.primary,
                        width: 48,
                        height: 48,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Post image
          GestureDetector(
            onTap: () => SliderFullImages(
              listImagesModel: [widget.post.imageUrl],
              current: 0,
            ),
            onDoubleTap: toggleLikePost,
            child: CachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              placeholder: (context, url) => const AspectRatio(
                aspectRatio:
                    1.5, // Default aspect ratio for placeholder (e.g., 3:2)
                child: SizedBox(),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.primary,
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
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Row(
              children: [
                // Like button
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: PhysicalModel(
                          color: Colors.transparent,
                          elevation: 6.0,
                          shape: BoxShape.rectangle,
                          shadowColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.4),
                          child: SvgPicture.asset(
                            widget.post.likes.contains(currentUser!.uid)
                                ? 'assets/icons/ic_heart_filled.svg'
                                : 'assets/icons/ic_heart_border.svg',
                            color: (widget.post.likes.contains(currentUser!.uid)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onPrimary),
                            width: 24,
                            height: 24,
                          ),
                        ),
                        // Icon(
                        //   widget.post.likes.contains(currentUser!.uid)
                        //       ? Icons.favorite
                        //       : Icons.favorite_border,
                        //   color: widget.post.likes.contains(currentUser!.uid)
                        //       ? Colors.red[700]
                        //       : Theme.of(context).colorScheme.primary,
                        // ),
                      ),
                      const SizedBox(width: 3),
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
                // Comment button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: PhysicalModel(
                    color: Colors.transparent,
                    elevation: 6.0,
                    shape: BoxShape.rectangle,
                    shadowColor:
                        Theme.of(context).colorScheme.surface.withOpacity(0.4),
                    child: SvgPicture.asset(
                      widget.post.comments.isNotEmpty
                          ? 'assets/icons/ic_comment_style_1.svg'
                          : 'assets/icons/ic_comment.svg',
                      color: widget.post.comments.isNotEmpty
                          ? Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.9)
                          : Theme.of(context).colorScheme.onPrimary,
                      width: widget.post.comments.isNotEmpty ? 26 : 22,
                      height: widget.post.comments.isNotEmpty ? 26 : 22,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.userName,
                  style: AppTextStyles.textStylePost.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: AppDimens.textSizeRegular,
                  ),
                ),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 100,
                      minWidth: double.infinity), // Limit height
                  child: SingleChildScrollView(
                    child: Text(
                      widget.post.text.replaceAll("\\n", "\n"),
                      style: AppTextStyles.textStylePost.copyWith(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: AppDimens.textSizeRegular,
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
              padding: const EdgeInsets.only(right: 200, left: 8.0),
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
                  padding: const EdgeInsets.symmetric(vertical: 4),
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
