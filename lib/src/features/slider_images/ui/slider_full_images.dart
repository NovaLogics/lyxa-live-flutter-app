import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderFullImages extends StatefulWidget {
  final List<String> listImagesModel;
  final int current;

  const SliderFullImages({
    super.key,
    required this.listImagesModel,
    required this.current,
  });

  @override
  _SliderFullImagesState createState() => _SliderFullImagesState();
}

class _SliderFullImagesState extends State<SliderFullImages> {
  int _current = 0;
  bool _stateChange = false;

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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {},
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
                    _stateChange = true;
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(widget.listImagesModel, (index, _) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 10.0,
                height: 10.0,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (_current == index) ? Colors.redAccent : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
