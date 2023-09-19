extension IsbnExtension on String {
  int? isbnTryParse(String value) {
    value = value.replaceAll('-', '');
    if (value.isNotEmpty && value.length == 13) {
      int? isbn = int.tryParse(value);
      return isbn;
    }
    return null;
  }
}
