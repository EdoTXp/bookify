// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookify/src/shared/services/book_service/book_service.dart';

part 'book_detail_bloc_event.dart';
part 'book_detail_bloc_state.dart';

class BookDetailBlocBloc
    extends Bloc<BookDetailBlocEvent, BookDetailBlocState> {
  final BookService _bookService;

  BookDetailBlocBloc(
    this._bookService,
  ) : super(BookDetailBlocInitial()) {
    on<BookDetailBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
