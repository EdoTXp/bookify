part of 'readings_insertion_bloc.dart';

sealed class ReadingsInsertionState {}

final class ReadingsInsertionLoadingState extends ReadingsInsertionState {}

final class ReadingsInsertionInsertedState extends ReadingsInsertionState {}

final class ReadingsInsertionErrorState extends ReadingsInsertionState {
  final String errorMessage;

  ReadingsInsertionErrorState({
    required this.errorMessage,
  });
}
