import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/previewer/cubits/slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderInitial());

  void showSlider(List<String> images, int currentIndex) {
    emit(SliderLoaded(
      images,
      currentIndex,
    ));
  }

  void hideSlider() {
    emit(SliderVisibility(false));
  }
}
