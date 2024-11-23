import 'package:lyxa_live/src/core/resources/app_strings.dart';

class LoadingState {
  final bool isVisible;
  final String message;

  LoadingState({
    this.isVisible = false,
    this.message = AppStrings.pleaseWait,
  });

  LoadingState copyWith({bool? isVisible, String? message}) {
    return LoadingState(
      isVisible: isVisible ?? this.isVisible,
      message: message ?? this.message,
    );
  }
}
