import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/shared/event_handlers/errors/utils/error_type.dart';
import 'error_state.dart';

class ErrorCubit extends Cubit<ErrorState> {
  ErrorCubit() : super(ErrorHidden());

  /// Display an error with an optional custom message
  void showError(ErrorType errorType, {String? customMessage}) {
    emit(ErrorVisible(errorType: errorType, customMessage: customMessage));
  }

  /// Hide the error
  void hideError() {
    emit(ErrorHidden());
  }
}
