part of 'readings_insertion_bloc.dart';

sealed class ReadingsInsertionEvent {}

final class InsertedReadingsEvent extends ReadingsInsertionEvent {
  final String bookId;
  final int? pagesUpdated;

  InsertedReadingsEvent({
    required this.bookId,
    this.pagesUpdated,
  });
}
