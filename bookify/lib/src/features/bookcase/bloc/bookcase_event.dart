part of 'bookcase_bloc.dart';

sealed class BookcaseEvent {}

final class GotAllBookcasesEvent extends BookcaseEvent {}

final class DeletedBookcasesEvent extends BookcaseEvent {
  final List<BookcaseDto> selectedList;

  DeletedBookcasesEvent({
    required this.selectedList,
  });
}
