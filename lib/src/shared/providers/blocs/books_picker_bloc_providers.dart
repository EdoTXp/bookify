import 'package:bookify/src/features/books_picker/views/widgets/book_on_bookcase_picker/bloc/book_on_bookcase_picker_bloc.dart';
import 'package:bookify/src/features/books_picker/views/widgets/bookcase_picker/bloc/bookcase_picker_bloc.dart';
import 'package:bookify/src/features/books_picker/views/widgets/separate_books_picker/bloc/separate_books_picker_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final booksPickerBlocProviders = [
  BlocProvider<BookcasePickerBloc>(
    create: (context) => BookcasePickerBloc(
      context.read(),
      context.read(),
    ),
  ),
  BlocProvider<BookOnBookcasePickerBloc>(
    create: (context) => BookOnBookcasePickerBloc(
      context.read(),
      context.read(),
    ),
  ),
  BlocProvider<SeparateBooksPickerBloc>(
    create: (context) => SeparateBooksPickerBloc(
      context.read(),
    ),
  )
];
