import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/bookcase/bloc/bookcase_bloc.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:bookify/src/shared/services/bookcase_service/bookcase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookServiceMock extends Mock implements BookService {}

class BookcaseServiceMock extends Mock implements BookcaseService {}

void main() {
  final bookService = BookServiceMock();
  final bookcaseService = BookcaseServiceMock();
  late BookcaseBloc bookcaseBloc;

  final bookcasesModel = [
    BookcaseModel(
      id: 1,
      name: 'name',
      description: 'description',
      color: Colors.red,
    ),
    BookcaseModel(
      id: 2,
      name: 'name2',
      description: 'description2',
      color: Colors.pink,
    ),
  ];

  setUp(() {
    bookcaseBloc = BookcaseBloc(
      bookService,
      bookcaseService,
    );
  });

  group('Test bookcase Bloc || ', () {
    blocTest(
      'Initial state is empty',
      build: () => bookcaseBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'test if GotAllBookcaseEvent work',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getAllBookcases())
            .thenAnswer((_) async => bookcasesModel);

        when(() => bookcaseService.getBookIdForImagePreview(
                bookcaseId: any(named: 'bookcaseId')))
            .thenAnswer((_) async => 'bookId');

        when(() => bookService.getBookImage(id: any(named: 'id')))
            .thenAnswer((_) async => 'bookImg');
      },
      act: (bloc) => bloc.add(GotAllBookcasesEvent()),
      verify: (_) {
        verify(() => bookcaseService.getAllBookcases()).called(1);
        verify(
          () => bookcaseService.getBookIdForImagePreview(
              bookcaseId: any(named: 'bookcaseId')),
        ).called(2);
        verify(() => bookService.getBookImage(id: any(named: 'id'))).called(2);
      },
      expect: () => [
        isA<BookcaseLoadingState>(),
        isA<BookcaseLoadedState>(),
      ],
    );

    blocTest(
      'test if GotAllBookcaseEvent work when is empty List',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getAllBookcases())
            .thenAnswer((_) async => []);
      },
      act: (bloc) => bloc.add(GotAllBookcasesEvent()),
      verify: (_) {
        verify(() => bookcaseService.getAllBookcases()).called(1);
        verifyNever(
          () => bookcaseService.getBookIdForImagePreview(
              bookcaseId: any(named: 'bookcaseId')),
        );
        verifyNever(() => bookService.getBookImage(id: any(named: 'id')));
      },
      expect: () => [
        isA<BookcaseLoadingState>(),
        isA<BookcaseEmptyState>(),
      ],
    );

    blocTest(
      'test if GotAllBookcaseEvent work when throw LocalDatabaseException',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getAllBookcases())
            .thenThrow(LocalDatabaseException('Error on Database'));
      },
      act: (bloc) => bloc.add(GotAllBookcasesEvent()),
      verify: (_) {
        verify(() => bookcaseService.getAllBookcases()).called(1);
        verifyNever(
          () => bookcaseService.getBookIdForImagePreview(
              bookcaseId: any(named: 'bookcaseId')),
        );
        verifyNever(() => bookService.getBookImage(id: any(named: 'id')));
      },
      expect: () => [
        isA<BookcaseLoadingState>(),
        isA<BookcaseErrorState>(),
      ],
    );

    blocTest(
      'test if GotAllBookcaseEvent work when throw Exception',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getAllBookcases())
            .thenThrow(Exception('Generic Error'));
      },
      act: (bloc) => bloc.add(GotAllBookcasesEvent()),
      verify: (_) {
        verify(() => bookcaseService.getAllBookcases()).called(1);
        verifyNever(
          () => bookcaseService.getBookIdForImagePreview(
              bookcaseId: any(named: 'bookcaseId')),
        );
        verifyNever(() => bookService.getBookImage(id: any(named: 'id')));
      },
      expect: () => [
        isA<BookcaseLoadingState>(),
        isA<BookcaseErrorState>(),
      ],
    );

    blocTest(
      'test if GotAllBookcaseEvent work when bookcaseId is null',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getAllBookcases()).thenAnswer((_) async => [
              BookcaseModel(
                name: 'name',
                description: 'description',
                color: Colors.black,
              ),
            ]);
      },
      act: (bloc) => bloc.add(GotAllBookcasesEvent()),
      verify: (_) {
        verify(() => bookcaseService.getAllBookcases()).called(1);
        verifyNever(
          () => bookcaseService.getBookIdForImagePreview(
              bookcaseId: any(named: 'bookcaseId')),
        );
        verifyNever(() => bookService.getBookImage(id: any(named: 'id')));
      },
      expect: () => [
        isA<BookcaseLoadingState>(),
        isA<BookcaseErrorState>(),
      ],
    );
  });
}
