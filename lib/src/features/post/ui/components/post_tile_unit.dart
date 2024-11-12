import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/ui/components/text_field_unit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/comment.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post.dart';
import 'package:lyxa_live/src/features/post/ui/components/comment_tile_unit.dart';
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
  // Cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  // Current user
  AppUser? currentUser;

  // Post user
  ProfileUser? postUser;

  // Comment text controller
  final commentTextController = TextEditingController();

  // On startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  void fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // LIKES
  //------> User tapped like button
  void toggleLikePost() {
    // Current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // Optimistically like & update UI
    setState(() {
      if (isLiked) {
        // Unlike
        widget.post.likes.remove(currentUser!.uid);
      } else {
        // Like
        widget.post.likes.add(currentUser!.uid);
      }
    });

    // Update like
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      // If there's and error, revert back to original values
      setState(() {
        if (isLiked) {
          // Revert unlike
          widget.post.likes.add(currentUser!.uid);
        } else {
          // Revert like
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  // COMMENTS
  //------> Open comment box -> Type new comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a new comment"),
        content: TextFieldUnit(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: const Text("Cancel"),
          ),
          // Save button
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

  //------> Add Comment
  void addComment() {
    final comment = commentTextController.text;
    // Create a new comment
    final newComment = Comment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: comment,
      timestamp: DateTime.now(),
    );

    if (comment.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  // Show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete this post?"),
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
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          // Top section
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(uid: widget.post.userId),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Pic
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl,
                          errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                          imageBuilder: (context, imageProvider) => Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ))
                      : const Icon(Icons.person),
                  const SizedBox(width: 12),
                  //Name
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Delete button
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showOptions,
                      child: AbsorbPointer(
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            // Loading
            placeholder: (context, url) => const SizedBox(
              height: 430,
            ),
            // Error -> Failed to load
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.primary,
            ),

            errorListener: (value) => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(value.toString()))),
          ),

          // Buttons -> Like, Comment, Timestamp
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Like
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: AbsorbPointer(
                          child: Icon(
                            widget.post.likes.contains(currentUser!.uid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.likes.contains(currentUser!.uid)
                                ? Colors.redAccent
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Like Count
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                // Comment
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: AbsorbPointer(
                    child: Icon(
                      Icons.comment,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                const Spacer(),

                // Timestamp
                Text(
                  widget.post.timestamp.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.normal,
                  ),
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
                // Username
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                // Text
                Text(
                  widget.post.text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),

          // Comment Section
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              // Loaded
              if (state is PostLoaded) {
                // Final individual post
                final post = state.posts
                    .firstWhere((post) => (post.id == widget.post.id));

                if (post.comments.isNotEmpty) {
                  // How many comments to show
                  int showCommentCount = post.comments.length;

                  // Comment section
                  return ListView.builder(
                    itemCount: showCommentCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // Get individual comment
                      final comment = post.comments[index];

                      // Comment tile UI
                      return CommentTileUnit(
                        comment: comment,
                      );
                    },
                  );
                }
              }

              // Loading
              if (state is PostLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Error
              else if (state is PostError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return const Center(
                  child: SizedBox(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
