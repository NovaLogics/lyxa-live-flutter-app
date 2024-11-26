import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';

class ProfileImage extends StatefulWidget {
  final String imageUrl;

  const ProfileImage({super.key, required this.imageUrl});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _startFadeInTimer();
  }

  void _startFadeInTimer() {
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: _isVisible ? 1.0 : 0.0,
      child: Center(
        child: Material(
          elevation: AppDimens.elevationSM2,
          shape: const CircleBorder(),
          color: Theme.of(context).colorScheme.outline,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingXS1),
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              placeholder: (_, __) => const CircularProgressIndicator(),
              errorWidget: (_, __, ___) => SizedBox(
                height: AppDimens.imageSize120,
                child: Icon(
                  Icons.person_rounded,
                  size: AppDimens.iconSizeXXL96,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              imageBuilder: (_, imageProvider) => Container(
                height: AppDimens.imageSize120,
                width: AppDimens.imageSize120,
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
      ),
    );
  }
}
