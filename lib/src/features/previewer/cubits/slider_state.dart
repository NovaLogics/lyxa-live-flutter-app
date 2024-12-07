abstract class SliderState {}

class SliderInitial extends SliderState {}

class SliderLoading extends SliderState {}

class SliderVisibility extends SliderState {
  final bool isVisible;

  SliderVisibility(this.isVisible);
}

class SliderLoaded extends SliderState {
  final List<String> images;
  final int currentIndex;

  SliderLoaded(this.images, this.currentIndex);
}

class SliderError extends SliderState {
  final String message;

  SliderError(this.message);
}
