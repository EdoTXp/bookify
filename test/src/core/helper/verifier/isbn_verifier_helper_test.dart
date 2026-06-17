import 'package:bookify/src/core/helper/verifier/isbn_verifier_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('valid ISBN ||', () {
    test('test if a 978-85-7307-610-3 is a valid isbn', () {
      String str1 = '978-85-7307-610-3';

      String? isbn = IsbnVerifierHelper.verifyIsbn(str1);

      expect(isbn, equals('9788573076103'));
    });

    test('test if valid ISBN and remove empty spaces', () {
      String input = ' 9798558244588     ';

      String? isbn = IsbnVerifierHelper.verifyIsbn(input);

      expect(isbn, equals('9798558244588'));
    });

    test('test if a 88-515-2159-X is a valid isbn', () {
      String str2 = '88-515-2159-X';

      String? isbn = IsbnVerifierHelper.verifyIsbn(str2);

      expect(isbn, equals('885152159x'));
    });

    test('test if a 9788576086475 is a valid isbn', () {
      String str3 = '9788576086475';

      String? isbn = IsbnVerifierHelper.verifyIsbn(str3);

      expect(isbn, equals('9788576086475'));
    });
  });

  group('invalid ISBN ||', () {
    test('test if a 978-1-12345-909-4 2 is a invalid isbn', () {
      String str4 = '978-1-12345-909-4 2';

      String? isbn = IsbnVerifierHelper.verifyIsbn(str4);

      expect(isbn, equals(null));
    });

    test('test if a ISBN446877428FCI 2 is a invalid isbn', () {
      String str5 = 'ISBN446877428FCI';

      String? isbn = IsbnVerifierHelper.verifyIsbn(str5);

      expect(isbn, equals(null));
    });
  });
}
