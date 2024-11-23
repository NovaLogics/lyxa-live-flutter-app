import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/shared/event_handlers/loading/cubits/loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingState());

  void show({String? message}) {
    emit(state.copyWith(isVisible: true, message: message));
  }

  void hide() {
    emit(state.copyWith(isVisible: false));
  }
}