part of 'bookcase_insertion_bloc.dart';

sealed class BookcaseInsertionEvent {}

final class InsertedBookcaseEvent extends BookcaseInsertionEvent {
  final String name;
  final String? description;
  final int colorValue;

  InsertedBookcaseEvent({
    required this.name,
    this.description,
    required this.colorValue,
  });
}

final class UpdatedBookcaseEvent extends BookcaseInsertionEvent {
  final int id;
  final String name;
  final String? description;
  final int colorValue;

  UpdatedBookcaseEvent({
    required this.id,
    required this.name,
    this.description,
    required this.colorValue,
  });
}
