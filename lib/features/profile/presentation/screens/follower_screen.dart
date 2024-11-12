import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FollowerScreen extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerScreen({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold());
  }
}
