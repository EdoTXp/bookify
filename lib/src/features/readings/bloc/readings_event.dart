part of 'readings_bloc.dart';

sealed class ReadingsEvent {}

final class GotAllReadingsEvent extends ReadingsEvent {}

final class FoundReadingByBookTitleEvent extends ReadingsEvent {
  final String searchQueryName;

  FoundReadingByBookTitleEvent({
    required this.searchQueryName,
  });
}
