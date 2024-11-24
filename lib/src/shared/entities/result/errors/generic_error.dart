class GenericError {
  final String? message;
  final Object? error;

  GenericError({this.message, this.error});

  String describe() {
    return message ?? error?.toString() ?? "Unknown error";
  }
}