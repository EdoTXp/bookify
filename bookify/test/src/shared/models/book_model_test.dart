import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookModel', () {
    final book1 = BookModel(
      id: '1',
      title: 'Book 1',
      authors: [AuthorModel(name: 'Author 1')],
      publisher: 'Publisher 1',
      description: 'Description 1',
      categories: [CategoryModel(name: 'Category 1')],
      pageCount: 100,
      imageUrl: 'image_url_1',
      buyLink: 'buy_link_1',
      averageRating: 4.5,
      ratingsCount: 100,
    );
    final book2 = BookModel(
      id: '2',
      title: 'Book 2',
      authors: [AuthorModel(name: 'Author 2')],
      publisher: 'Publisher 2',
      description: 'Description 2',
      categories: [CategoryModel(name: 'Category 2')],
      pageCount: 200,
      imageUrl: 'image_url_2',
      buyLink: 'buy_link_2',
      averageRating: 3.5,
      ratingsCount: 200,
    );

    final book3 = BookModel(
      id: '1',
      title: 'title',
      authors: [AuthorModel(name: 'Author')],
      publisher: 'publisher',
      description: 'description',
      categories: [CategoryModel(name: 'Category')],
      pageCount: 320,
      imageUrl: 'imageUrl',
      buyLink: 'buyLink',
      averageRating: 2.5,
      ratingsCount: 2,
      status: BookStatus.library,
    );
    test(
        'should return false when comparing instances with different properties',
        () {
      expect(book1 == book2, false);
    });

    test(
        'should return a different hashCode for instances with different properties',
        () {
      expect(book1.hashCode != book2.hashCode, true);
    });

    test(
        'must transform the BookModel into a map and convert it back to an object',
        () {
      final bookMap = book3.toMap();

      expect(
        bookMap,
        {
          'id': '1',
          'title': 'title',
          'authors': [
            {
              'id': null,
              'name': 'Author',
            },
          ],
          'publisher': 'publisher',
          'description': 'description',
          'categories': [
            {
              'id': null,
              'name': 'Category',
            },
          ],
          'pageCount': 320,
          'imageUrl': 'imageUrl',
          'buyLink': 'buyLink',
          'averageRating': 2.5,
          'ratingsCount': 2,
          'status': 1,
        },
      );

      final bookFromMap = BookModel.fromMap(bookMap);

      expect(bookFromMap.id, '1');
      expect(bookFromMap.title, 'title');
      expect(bookFromMap.authors, isA<List<AuthorModel>>());
      expect(bookFromMap.publisher, 'publisher');
      expect(bookFromMap.description, 'description');
      expect(bookFromMap.categories, isA<List<CategoryModel>>());
      expect(bookFromMap.pageCount, 320);
      expect(bookFromMap.imageUrl, 'imageUrl');
      expect(bookFromMap.buyLink, 'buyLink');
      expect(bookFromMap.averageRating, 2.5);
      expect(bookFromMap.ratingsCount, 2);
      expect(bookFromMap.status, isA<BookStatus>());
    });
  });
}
