import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingState());

  Timer? _loadingScreenhideTimer;
  Timer? _visibilityDelayTimer;

  void show({String? message, Duration? timeout}) {
    _loadingScreenhideTimer?.cancel();
    _visibilityDelayTimer?.cancel();

    emit(state.copyWith(isVisible: true, message: message));

    if (timeout != null) {
      _loadingScreenhideTimer = Timer(timeout, () {
        hide(); 
      });
    }
  }

  void hide() {
    if (state.isVisible) {
      _loadingScreenhideTimer?.cancel();

      _visibilityDelayTimer = Timer(const Duration(seconds: 2), () {
        emit(state.copyWith(isVisible: false));
      });
    }
  }

  @override
  Future<void> close() {
    _loadingScreenhideTimer?.cancel();
    _visibilityDelayTimer?.cancel();
    return super.close();
  }


  static void showLoading({String? message, Duration? timeout}) {
    getIt<LoadingCubit>().show(message: message, timeout: timeout);
  }

  static void hideLoading() {
    getIt<LoadingCubit>().hide();
  }
}

