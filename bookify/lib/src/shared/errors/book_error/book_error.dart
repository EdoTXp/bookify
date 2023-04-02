class BookException implements Exception {
  final String message;

  BookException(this.message);

  @override
  String toString() {
    return "Book Exception: $message";
  }
}

class BookNotFoundException extends BookException {
  BookNotFoundException(super.message);

  @override
  String toString() {
    return "BookNotFoundException: $message";
  }
}
