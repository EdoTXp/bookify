part of 'readings_detail_bloc.dart';

sealed class ReadingsDetailEvent {}

final class UpdatedReadingsEvent extends ReadingsDetailEvent {
  final ReadingModel readingModel;

  UpdatedReadingsEvent({
    required this.readingModel,
  });
}

final class FinishedReadingsEvent extends ReadingsDetailEvent {
  final int readingId;
  final String bookId;

  FinishedReadingsEvent({
    required this.readingId,
    required this.bookId,
  });
}
