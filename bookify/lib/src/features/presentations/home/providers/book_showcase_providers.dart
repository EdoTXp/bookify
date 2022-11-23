import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../book/bloc/book_bloc.dart';
import '../../../book/services/dio_http_service.dart';
import '../../../book/services/google_books_service.dart';
import '../../../book/services/interfaces/books_service_interface.dart';
import '../../../book/services/interfaces/http_service_interface.dart';

final bookShowcaseProviders = [
  Provider<IHttpService>(create: ((_) => DioHttpService())),
  Provider<IBooksService>(
      create: ((context) => GoogleBookService(context.read()))),
  BlocProvider<BookBloc>(create: ((context) => BookBloc(context.read())))
];
