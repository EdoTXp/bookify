part of 'book_detail_bloc.dart';

sealed class BookDetailEvent {}

final class VerifiedBookIsInsertedEvent extends BookDetailEvent {
  final String bookId;

  VerifiedBookIsInsertedEvent({
    required this.bookId,
  });
}

final class BookInsertedEvent extends BookDetailEvent {
  final BookModel bookModel;

  BookInsertedEvent({
    required this.bookModel,
  });
}

final class BookRemovedEvent extends BookDetailEvent {
  final String bookId;

  BookRemovedEvent({
    required this.bookId,
  });
}
