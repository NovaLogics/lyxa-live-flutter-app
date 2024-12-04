import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingState());

  Timer? _loadingScreenHideTimer;
  Timer? _visibilityDelayTimer;

  void show({String? message, Duration? timeout}) {
    _loadingScreenHideTimer?.cancel();
    _visibilityDelayTimer?.cancel();

    emit(state.copyWith(isVisible: true, message: message));

    if (timeout != null) {
      _loadingScreenHideTimer = Timer(timeout, () {
        hide();
      });
    }
  }

  void hide() {
    if (state.isVisible) {
      _loadingScreenHideTimer?.cancel();

      _visibilityDelayTimer = Timer(const Duration(seconds: 1), () {
        emit(state.copyWith(isVisible: false));
      });
    }
  }

  @override
  Future<void> close() {
    _loadingScreenHideTimer?.cancel();
    _visibilityDelayTimer?.cancel();
    return super.close();
  }

  static void showLoading({String? message, Duration? timeout}) {
    getIt<LoadingCubit>()
        .show(message: message, timeout: const Duration(seconds: 60));
  }

  static void hideLoading() {
    getIt<LoadingCubit>().hide();
  }
}
