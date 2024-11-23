import 'package:lyxa_live/src/shared/event_handlers/errors/utils/error_type.dart';

abstract class ErrorState {}

class ErrorHidden extends ErrorState {}

class ErrorVisible extends ErrorState {
  final ErrorType errorType;
  final String? customMessage;

  ErrorVisible({
    required this.errorType,
    this.customMessage,
  });
}
