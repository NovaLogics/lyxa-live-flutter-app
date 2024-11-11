import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lyxa_live/features/post/domain/entities/post.dart';

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Name
            Text(widget.post.userName),
            // Delete button
            IconButton(
              onPressed: showOptions,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
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
      ],
    );
  }
}
