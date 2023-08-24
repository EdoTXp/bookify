import 'package:bookify/src/shared/models/book_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookModel', () {
    test('should return false when comparing instances with different properties', () {
      final book1 = BookModel(
        id: '1',
        title: 'Book 1',
        authors: ['Author 1'],
        publisher: 'Publisher 1',
        description: 'Description 1',
        categories: ['Category 1'],
        pageCount: 100,
        imageUrl: 'image_url_1',
        buyLink: 'buy_link_1',
        averageRating: 4.5,
        ratingsCount: 100,
      );

      final book2 = BookModel(
        id: '2',
        title: 'Book 2',
        authors: ['Author 2'],
        publisher: 'Publisher 2',
        description: 'Description 2',
        categories: ['Category 2'],
        pageCount: 200,
        imageUrl: 'image_url_2',
        buyLink: 'buy_link_2',
        averageRating: 3.5,
        ratingsCount: 200,
      );

      expect(book1 == book2, false);
    });

    test('should return a different hashCode for instances with different properties', () {
      final book1 = BookModel(
        id: '1',
        title: 'Book 1',
        authors: ['Author 1'],
        publisher: 'Publisher 1',
        description: 'Description 1',
        categories: ['Category 1'],
        pageCount: 100,
        imageUrl: 'image_url_1',
        buyLink: 'buy_link_1',
        averageRating: 4.5,
        ratingsCount: 100,
      );

      final book2 = BookModel(
        id: '2',
        title: 'Book 2',
        authors: ['Author 2'],
        publisher: 'Publisher 2',
        description: 'Description 2',
        categories: ['Category 2'],
        pageCount: 200,
        imageUrl: 'image_url_2',
        buyLink: 'buy_link_2',
        averageRating: 3.5,
        ratingsCount: 200,
      );

      expect(book1.hashCode != book2.hashCode, true);
    });
  });
}
