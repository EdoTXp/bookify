part of 'bookcase_insertion_bloc.dart';

@immutable
sealed class BookcaseInsertionEvent {}

final class InsertedBookcaseEvent extends BookcaseInsertionEvent {
  final String name;
  final String? description;
  final Color color;

  InsertedBookcaseEvent({
    required this.name,
    this.description,
    required this.color,
  });
}

final class UpdatedBookcaseEvent extends BookcaseInsertionEvent {
  final int id;
  final String name;
  final String? description;
  final Color color;

  UpdatedBookcaseEvent({
    required this.id,
    required this.name,
    this.description,
    required this.color,
  });
}
