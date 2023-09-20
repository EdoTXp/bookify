import 'package:bookify/src/shared/helpers/isbn_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('valid ISBN ||', () {
    test('test if a 978-85-7307-610-3 is a valid isbn', () {
      String str1 = '978-85-7307-610-3';

      int? isbn = str1.isbnTryParse(str1);

      expect(isbn, equals(9788573076103));
    });

    test('test if a 1-56619-909-3 is a valid isbn', () {
      String str2 = "1-56619-909-3";

      int? isbn = str2.isbnTryParse(str2);

      expect(isbn, equals(1566199093));
    });

    test('test if a 1207199818865 is a valid isbn', () {
      String str3 = "1207199818865";

      int? isbn = str3.isbnTryParse(str3);

      expect(isbn, equals(1207199818865));
    });
  });

  group('invalid ISBN ||', () {
    test('test if a 978-1-12345-909-4 2 is a invalid isbn', () {
      String str4 = "978-1-12345-909-4 2";

      int? isbn = str4.isbnTryParse(str4);

      expect(isbn, equals(null));
    });

    test('test if a ISBN446877428FCI 2 is a invalid isbn', () {
      String str5 = "ISBN446877428FCI";

      int? isbn = str5.isbnTryParse(str5);

      expect(isbn, equals(null));
    });
  });
}
