import 'package:flutter/material.dart';
import 'package:lyxa_live/features/post/domain/entities/comment.dart';

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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          // Username
          Text(
            widget.comment.userName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),

          // Comment Text
          Text(
            widget.comment.text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),

          // Delete button
        ],
      ),
    );
  }
}
