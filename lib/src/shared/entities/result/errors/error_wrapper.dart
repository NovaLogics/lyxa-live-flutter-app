import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';

class ErrorWrapper {
  final GenericError? genericError;
  final FirebaseError? firebaseError;

  ErrorWrapper({this.genericError, this.firebaseError});

  bool get isFirebaseError => firebaseError != null;
  bool get isGenericError => genericError != null;
}