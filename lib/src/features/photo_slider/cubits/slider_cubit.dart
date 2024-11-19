import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderInitial());

  void showSlider(List<String> images, int currentIndex) {
    emit(SliderLoaded(
      images,
      currentIndex,
    ));
    // emit(SliderVisibility(true));
  }

  void hideSlider() {
    emit(SliderVisibility(false));
  }
}
