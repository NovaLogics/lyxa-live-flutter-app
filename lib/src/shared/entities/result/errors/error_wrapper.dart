import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/message_error.dart';

class ErrorWrapper {
  final GenericError? genericError;
  final FirebaseError? firebaseError;
  final MessageError? messageError;

  ErrorWrapper({this.genericError, this.firebaseError, this.messageError});

  bool get isFirebaseError => firebaseError != null;
  bool get isGenericError => genericError != null;
  bool get isMessageError => messageError != null;
}