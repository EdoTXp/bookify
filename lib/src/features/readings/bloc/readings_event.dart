part of 'readings_bloc.dart';

sealed class ReadingsEvent {}

final class GotAllReadingsEvent extends ReadingsEvent {}

final class FindedReadingByBookTitleEvent extends ReadingsEvent {
  final String searchQueryName;

  FindedReadingByBookTitleEvent({
    required this.searchQueryName,
  });
}
