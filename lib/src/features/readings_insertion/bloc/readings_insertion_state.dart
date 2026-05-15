part of 'readings_insertion_bloc.dart';

sealed class ReadingsInsertionState {}

final class ReadingsInsertionLoadingState extends ReadingsInsertionState {}

final class ReadingsInsertionInsertedState extends ReadingsInsertionState {}

final class ReadingsInsertionErrorState extends ReadingsInsertionState {
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  ReadingsInsertionErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
