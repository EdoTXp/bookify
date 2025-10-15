class BookException implements Exception {
  final String message;

  const BookException(this.message);

  @override
  String toString() {
    return 'Book Exception: $message';
  }
}

class BookNotFoundException extends BookException {
  const BookNotFoundException(super.message);

  @override
  String toString() {
    return 'BookNotFoundException: $message';
  }
}
