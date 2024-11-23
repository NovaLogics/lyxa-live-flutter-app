import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/shared/event_handlers/loading/cubits/loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingState());

  void show({String? message}) {
    emit(state.copyWith(isVisible: true, message: message));
  }

  void hide() {
    emit(state.copyWith(isVisible: false));
  }

  // Add static shortcut methods for convenience
  static void showLoading(String? message) {
    getIt<LoadingCubit>().show(message: message);
  }

  static void hideLoading() {
    getIt<LoadingCubit>().hide();
  }
}