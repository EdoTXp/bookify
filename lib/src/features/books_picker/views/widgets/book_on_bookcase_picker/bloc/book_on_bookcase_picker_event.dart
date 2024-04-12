part of 'book_on_bookcase_picker_bloc.dart';

sealed class BookOnBookcasePickerEvent {}

final class GotAllBookOnBookcasePickerEvent extends BookOnBookcasePickerEvent {
  final int bookcaseId;

  GotAllBookOnBookcasePickerEvent({
    required this.bookcaseId,
  });
}
