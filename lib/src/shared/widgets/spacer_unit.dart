import 'package:flutter/material.dart';

/// A widget that adds space with customizable [height] and [width].
class SpacerUnit extends StatelessWidget {
  final double height;
  final double width;

  const SpacerUnit({this.height = 0.0, this.width = 0.0, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}