import 'package:bookify/src/shared/verifier/isbn_verifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final verifier = IsbnVerifier();
  group('valid ISBN ||', () {
    test('test if a 978-85-7307-610-3 is a valid isbn', () {
      String str1 = '978-85-7307-610-3';

      String? isbn = verifier.isbnTryParse(str1);

      expect(isbn, equals('9788573076103'));
    });

    test('test if a 88-515-2159-X is a valid isbn', () {
      String str2 = "88-515-2159-X";

      String? isbn = verifier.isbnTryParse(str2);

      expect(isbn, equals('885152159x'));
    });

    test('test if a 9788576086475 is a valid isbn', () {
      String str3 = "9788576086475";

      String? isbn = verifier.isbnTryParse(str3);

      expect(isbn, equals('9788576086475'));
    });
  });

  group('invalid ISBN ||', () {
    test('test if a 978-1-12345-909-4 2 is a invalid isbn', () {
      String str4 = "978-1-12345-909-4 2";

      String? isbn = verifier.isbnTryParse(str4);

      expect(isbn, equals(null));
    });

    test('test if a ISBN446877428FCI 2 is a invalid isbn', () {
      String str5 = "ISBN446877428FCI";

      String? isbn = verifier.isbnTryParse(str5);

      expect(isbn, equals(null));
    });
  });
}
