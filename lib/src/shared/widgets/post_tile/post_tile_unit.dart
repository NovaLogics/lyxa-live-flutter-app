import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/utils/helper/date_time_util.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/shared/widgets/custom_toast.dart';
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
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile picture
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl!,
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
                  const SizedBox(width: 12),
                  // User name
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimens.textSizeRegular,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    DateTimeUtil.datetimeAgo(
                      widget.post.timestamp,
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.normal,
                      fontSize: AppDimens.textSizeSmall,
                    ),
                  ),
                  const Spacer(),
                  // Delete option if it's the user's post
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showDeleteOptions,
                      child: Icon(Icons.delete,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                ],
              ),
            ),
          ),

          // Post image
          CachedNetworkImage(
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

          // Interaction buttons (Like, Comment, Timestamp)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Like button
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red[700]
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Like count
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                // Comment button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(Icons.comment_outlined,
                      color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12),
                ),
                const Spacer(),
                // Timestamp
                Text(
                  DateTimeUtil.formatDate(widget.post.timestamp,
                      format: DateTimeStyles.customShortDate),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),

          // Caption
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                Text(
                  widget.post.userName,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.post.text,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12),
                ),
              ],
            ),
          ),

          // Comments section
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoaded) {
                final post =
                    state.posts.firstWhere((p) => p.id == widget.post.id);
                return ListView.builder(
                  itemCount: post.comments.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      CommentTileUnit(comment: post.comments[index]),
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
          const Divider(
            height: 2,
            color: AppColors.blueGreyShade100,
          )
        ],
      ),
    );
  }
}
