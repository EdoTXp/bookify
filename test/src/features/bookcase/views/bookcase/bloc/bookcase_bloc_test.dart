import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/bookcase/bloc/bookcase_bloc.dart';
import 'package:bookify/src/shared/dtos/bookcase_dto.dart';
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
      'test if GotAllBookcaseEvent work when throw Generic Exception',
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
      'test if FindedBookcaseByNameEvent work',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .thenAnswer((_) async => [
                  BookcaseModel(
                    id: 1,
                    name: 'Fantasia',
                    description: 'Fantasia Description',
                    color: Colors.black,
                  ),
                ]);
        when(() => bookcaseService.getBookIdForImagePreview(
                bookcaseId: any(named: 'bookcaseId')))
            .thenAnswer((_) async => 'bookId');

        when(() => bookService.getBookImage(id: any(named: 'id')))
            .thenAnswer((_) async => 'bookImg');
      },
      act: (bloc) =>
          bloc.add(FindedBookcaseByNameEvent(searchQueryName: 'Fantasia')),
      verify: (_) {
        verify(() =>
                bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .called(1);
        verify(
          () => bookcaseService.getBookIdForImagePreview(
              bookcaseId: any(named: 'bookcaseId')),
        ).called(1);
        verify(() => bookService.getBookImage(id: any(named: 'id'))).called(1);
      },
      expect: () => [
        isA<BookcaseLoadingState>(),
        isA<BookcaseLoadedState>(),
      ],
    );

    blocTest(
      'test if FindedBookcaseByNameEvent work hen is empty List',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .thenAnswer((_) async => []);
      },
      act: (bloc) =>
          bloc.add(FindedBookcaseByNameEvent(searchQueryName: 'Fantasia')),
      verify: (_) {
        verify(() =>
                bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .called(1);
        verifyNever(
          () => bookcaseService.getBookIdForImagePreview(
            bookcaseId: any(named: 'bookcaseId'),
          ),
        );
        verifyNever(
          () => bookService.getBookImage(
            id: any(named: 'id'),
          ),
        );
      },
      expect: () => [
        isA<BookcaseLoadingState>(),
        isA<BookcaseNotFoundState>(),
      ],
    );

    blocTest(
      'test if FindedBookcaseByNameEvent work when bookcaseId is null',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .thenAnswer((_) async => [
                  BookcaseModel(
                    name: 'Fantasia',
                    description: 'description',
                    color: Colors.black,
                  ),
                ]);
      },
      act: (bloc) =>
          bloc.add(FindedBookcaseByNameEvent(searchQueryName: 'Fantasia')),
      verify: (_) {
        verify(() =>
                bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .called(1);
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
      'test if FindedBookcaseByNameEvent work when throw LocalDatabaseException',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .thenThrow(LocalDatabaseException('Error on Database'));
      },
      act: (bloc) =>
          bloc.add(FindedBookcaseByNameEvent(searchQueryName: 'Fantasia')),
      verify: (_) {
        verify(() =>
                bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .called(1);
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
      'test if FindedBookcaseByNameEvent work when throw Generic Exception',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .thenThrow(Exception('Generic Error'));
      },
      act: (bloc) =>
          bloc.add(FindedBookcaseByNameEvent(searchQueryName: 'Fantasia')),
      verify: (_) {
        verify(() =>
                bookcaseService.getBookcasesByName(name: any(named: 'name')))
            .called(1);
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
      'test if DeletedBookcasesEvent work',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer((_) async => 1);
        when(() => bookcaseService.getAllBookcases())
            .thenAnswer((_) async => bookcasesModel);
        when(() => bookcaseService.getBookIdForImagePreview(
                bookcaseId: any(named: 'bookcaseId')))
            .thenAnswer((_) async => 'bookId');
        when(() => bookService.getBookImage(id: any(named: 'id')))
            .thenAnswer((_) async => 'bookImg');
      },
      act: (bloc) => bloc.add(
        DeletedBookcasesEvent(
          selectedList: [
            BookcaseDto(bookcase: bookcasesModel[1]),
          ],
        ),
      ),
      verify: (_) {
        verify(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId'))).called(1);
        verify(() => bookcaseService.getAllBookcases()).called(1);
        verify(
          () => bookcaseService.getBookIdForImagePreview(
            bookcaseId: any(named: 'bookcaseId'),
          ),
        ).called(2);
        verify(() => bookService.getBookImage(id: any(named: 'id'))).called(2);
      },
      expect: () => [
        isA<BookcaseLoadingState>(),
        isA<BookcaseLoadedState>(),
      ],
    );

    blocTest(
      'test if DeletedBookcasesEvent work with error on delete',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer((_) async => -1);
      },
      act: (bloc) => bloc.add(
        DeletedBookcasesEvent(
          selectedList: [
            BookcaseDto(bookcase: bookcasesModel[1]),
          ],
        ),
      ),
      verify: (_) {
        verify(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId'))).called(1);
        verifyNever(() => bookcaseService.getAllBookcases());
        verifyNever(
          () => bookcaseService.getBookIdForImagePreview(
            bookcaseId: any(named: 'bookcaseId'),
          ),
        );
        verifyNever(() => bookService.getBookImage(id: any(named: 'id')));
      },
      expect: () => [
        isA<BookcaseLoadingState>(),
        isA<BookcaseErrorState>(),
      ],
    );

    blocTest(
      'test if DeletedBookcasesEvent work with empty list',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer((_) async => 1);
        when(() => bookcaseService.getAllBookcases())
            .thenAnswer((_) async => []);
      },
      act: (bloc) => bloc.add(
        DeletedBookcasesEvent(
          selectedList: [
            BookcaseDto(bookcase: bookcasesModel[1]),
          ],
        ),
      ),
      verify: (_) {
        verify(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId'))).called(1);
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
      'test if DeletedBookcasesEvent work when throw LocalDatabaseException',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.deleteBookcase(
                bookcaseId: any(named: 'bookcaseId')))
            .thenThrow(LocalDatabaseException('Error on Database'));
      },
      act: (bloc) => bloc.add(
        DeletedBookcasesEvent(
          selectedList: [
            BookcaseDto(bookcase: bookcasesModel[1]),
          ],
        ),
      ),
      verify: (_) {
        verify(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId'))).called(1);
        verifyNever(() => bookcaseService.getAllBookcases());
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
      'test if DeletedBookcasesEvent work when throw Generic Exception',
      build: () => bookcaseBloc,
      setUp: () async {
        when(() => bookcaseService.deleteBookcase(
                bookcaseId: any(named: 'bookcaseId')))
            .thenThrow(Exception('Generic Exception'));
      },
      act: (bloc) => bloc.add(
        DeletedBookcasesEvent(
          selectedList: [
            BookcaseDto(bookcase: bookcasesModel[1]),
          ],
        ),
      ),
      verify: (_) {
        verify(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId'))).called(1);
        verifyNever(() => bookcaseService.getAllBookcases());
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
