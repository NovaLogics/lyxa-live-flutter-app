import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';

class PhotoSlider extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const PhotoSlider({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  // Generic function to map a list into widgets
  List<T> _mapListToWidgets<T>(
      List list, T Function(int index, dynamic item) handler) {
    return List.generate(list.length, (index) => handler(index, list[index]));
  }

  // AppBar widget
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.close_sharp,
          color: Colors.grey,
          size: AppDimens.size28,
        ),
        tooltip: AppStrings.closeButtonTooltip,
        onPressed: () => context.read<SliderCubit>().hideSlider(),
      ),
    );
  }

  // Body widget
  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCarouselSlider(context),
        const SizedBox(height: AppDimens.size12),
        if (widget.images.length > 1) _buildIndicator(),
        const SizedBox(height: AppDimens.size48),
      ],
    );
  }

  // Carousel Slider widget
  Widget _buildCarouselSlider(BuildContext context) {
    return Expanded(
      child: CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: false,
          height: MediaQuery.of(context).size.height,
          viewportFraction: 1.0,
          enableInfiniteScroll: false,
          onPageChanged: (index, _) => setState(() => _currentIndex = index),
          initialPage: widget.initialIndex,
        ),
        itemCount: widget.images.length,
        itemBuilder: (context, index, realIndex) {
          return _buildImageViewer(widget.images[index]);
        },
      ),
    );
  }

  // Image viewer widget with zoom support
  Widget _buildImageViewer(String imageUrl) {
    return InteractiveViewer(
      panEnabled: true,
      minScale: 1.0,
      maxScale: 4.0,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.blueGrey),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Indicator dots for carousel
  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _mapListToWidgets<Widget>(widget.images, (index, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: AppDimens.size8,
          height: AppDimens.size8,
          margin: const EdgeInsets.symmetric(horizontal: AppDimens.size4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                (_currentIndex == index) ? AppColors.gold400 : AppColors.gold50,
          ),
        );
      }),
    );
  }
}
