import 'package:firebase_core/firebase_core.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/firebase_error_handler.dart';

class FirebaseError {
  final String message;
  final String? code;

  // Constructor that accepts FirebaseException
  FirebaseError(FirebaseException error)
      : code = error.code,
        message = FirebaseErrorHandler.getMessage(error.code);
}