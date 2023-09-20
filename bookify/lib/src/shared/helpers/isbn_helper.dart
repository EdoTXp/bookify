// regexp finded on https://www.geeksforgeeks.org/regular-expressions-to-validate-isbn-code/
final isbnRegExp =
    RegExp(r'^(?=(?:[^0-9]*[0-9]){10}(?:(?:[^0-9]*[0-9]){3})?$)[\d-]+$');

extension IsbnExtension on String {
  int? isbnTryParse(String value) {
    if (value.isNotEmpty && isbnRegExp.hasMatch(value)) {
      value = value.replaceAll('-', '');
      int? isbn = int.tryParse(value);
      return isbn;
    }
    return null;
  }
}
