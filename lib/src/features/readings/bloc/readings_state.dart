part of 'readings_bloc.dart';

sealed class ReadingsState {}

final class ReadingsLoadingState extends ReadingsState {}

final class ReadingsEmptyState extends ReadingsState {}

final class ReadingsNotFoundState extends ReadingsState {}

final class ReadingsLoadedState extends ReadingsState {
  final List<ReadingDto> readingsDto;

  ReadingsLoadedState({required this.readingsDto});
}

final class ReadingsErrorState extends ReadingsState {
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  ReadingsErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
