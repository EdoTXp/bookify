part of 'book_on_bookcase_detail_bloc.dart';

sealed class BookOnBookcaseDetailEvent {}

final class GotCountOfBookcasesByBookEvent extends BookOnBookcaseDetailEvent {
  final String bookId;

  GotCountOfBookcasesByBookEvent({
    required this.bookId,
  });
}

final class DeletedBookOnBookcaseEvent extends BookOnBookcaseDetailEvent {
  final String bookId;
  final int bookcaseId;

  DeletedBookOnBookcaseEvent({
    required this.bookId,
    required this.bookcaseId,
  });
}
