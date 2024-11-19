import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';

class PhotoSlider extends StatefulWidget {
  final List<String> listImagesModel;
  final int current;

  const PhotoSlider({
    super.key,
    required this.listImagesModel,
    required this.current,
  });

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _current = widget.current;
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.close_sharp,
            color: Colors.grey,
            size: AppDimens.size28,
          ),
          onPressed: () {
            context.read<SliderCubit>().hideSlider();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CarouselSlider.builder(
              options: CarouselOptions(
                autoPlay: false,
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                onPageChanged: (index, _) {
                  setState(() {
                    _current = index;
                  });
                },
                initialPage: widget.current,
              ),
              itemCount: widget.listImagesModel.length,
              itemBuilder: (context, index, realIndex) {
                return InteractiveViewer(
                  panEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: widget.listImagesModel[index],
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimens.size12),
          if (widget.listImagesModel.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(widget.listImagesModel, (index, _) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: AppDimens.size8,
                  height: AppDimens.size8,
                  margin: const EdgeInsets.symmetric(horizontal: AppDimens.size4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_current == index)
                        ? AppColors.goldShade400
                        : AppColors.goldShade50,
                  ),
                );
              }),
            ),
          const SizedBox(height: AppDimens.size48),
        ],
      ),
    );
  }
}
