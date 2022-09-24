class BookException implements Exception {
  final String message;

  BookException(this.message);
}

class BookNotFoundException extends BookException{
  BookNotFoundException(super.message);
}

