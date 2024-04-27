part of 'readings_detail_bloc.dart';

sealed class ReadingsDetailState {}

final class ReadingsDetailLoadingState extends ReadingsDetailState {}

final class ReadingsDetailUpdatedState extends ReadingsDetailState {}

final class ReadingsDetailFinishedState extends ReadingsDetailState {}

final class ReadingsDetailErrorState extends ReadingsDetailState {
  final String errorMessage;

  ReadingsDetailErrorState({
    required this.errorMessage,
  });
}
