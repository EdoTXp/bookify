import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/bookcase_insertion/bloc/bookcase_insertion_bloc.dart';

import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:bookify/src/shared/services/bookcase_service/bookcase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookcaseServiceMock extends Mock implements BookcaseService {}

void main() {
  final bookcaseService = BookcaseServiceMock();
  late BookcaseInsertionBloc bookcaseInsertionBloc;

  final bookcaseModel = BookcaseModel(
    name: 'name',
    description: 'description',
    color: Colors.pink,
  );

  setUp(() {
    bookcaseInsertionBloc = BookcaseInsertionBloc(
      bookcaseService,
    );
  });

  group('Test bookcaseInsertionBloc ||', () {
    blocTest(
      'Initial state is empty',
      build: () => bookcaseInsertionBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test InsertedBookcaseEvent() work',
      build: () => bookcaseInsertionBloc,
      setUp: () => when(() =>
              bookcaseService.insertBookcase(bookcaseModel: bookcaseModel))
          .thenAnswer((_) async => 4),
      act: (bloc) => bloc.add(InsertedBookcaseEvent(
        name: 'name',
        description: 'description',
        color: Colors.pink,
      )),
      verify: (_) {
        verify(() =>
                bookcaseService.insertBookcase(bookcaseModel: bookcaseModel))
            .called(1);
      },
      expect: () => [
        isA<BookcaseInsertionLoadingState>(),
        isA<BookcaseInsertionLoadedState>(),
      ],
    );

    blocTest(
      'Test InsertedBookcaseEvent() with Error on insertion work',
      build: () => bookcaseInsertionBloc,
      setUp: () => when(() =>
              bookcaseService.insertBookcase(bookcaseModel: bookcaseModel))
          .thenAnswer((_) async => 0),
      act: (bloc) => bloc.add(InsertedBookcaseEvent(
        name: 'name',
        description: 'description',
        color: Colors.pink,
      )),
      verify: (_) {
        verify(() =>
                bookcaseService.insertBookcase(bookcaseModel: bookcaseModel))
            .called(1);
      },
      expect: () => [
        isA<BookcaseInsertionLoadingState>(),
        isA<BookcaseInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedBookcaseEvent() with LocalDatabaseException work',
      build: () => bookcaseInsertionBloc,
      setUp: () => when(() =>
              bookcaseService.insertBookcase(bookcaseModel: bookcaseModel))
          .thenThrow(LocalDatabaseException('Error on database')),
      act: (bloc) => bloc.add(InsertedBookcaseEvent(
        name: 'name',
        description: 'description',
        color: Colors.pink,
      )),
      verify: (_) {
        verify(() =>
                bookcaseService.insertBookcase(bookcaseModel: bookcaseModel))
            .called(1);
      },
      expect: () => [
        isA<BookcaseInsertionLoadingState>(),
        isA<BookcaseInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedBookcaseEvent() with generic Exception work',
      build: () => bookcaseInsertionBloc,
      setUp: () => when(() =>
              bookcaseService.insertBookcase(bookcaseModel: bookcaseModel))
          .thenThrow(Exception('Generic Exception')),
      act: (bloc) => bloc.add(InsertedBookcaseEvent(
        name: 'name',
        description: 'description',
        color: Colors.pink,
      )),
      verify: (_) {
        verify(() =>
                bookcaseService.insertBookcase(bookcaseModel: bookcaseModel))
            .called(1);
      },
      expect: () => [
        isA<BookcaseInsertionLoadingState>(),
        isA<BookcaseInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test UpdatedBookcaseEvent() work',
      build: () => bookcaseInsertionBloc,
      setUp: () => when(
        () => bookcaseService.updateBookcase(
          bookcaseModel: bookcaseModel.copyWith(id: 1),
        ),
      ).thenAnswer((_) async => 1),
      act: (bloc) => bloc.add(UpdatedBookcaseEvent(
        id: 1,
        name: 'name',
        description: 'description',
        color: Colors.pink,
      )),
      verify: (_) {
        verify(() => bookcaseService.updateBookcase(
            bookcaseModel: bookcaseModel.copyWith(id: 1))).called(1);
      },
      expect: () => [
        isA<BookcaseInsertionLoadingState>(),
        isA<BookcaseInsertionLoadedState>(),
      ],
    );

    blocTest(
      'Test UpdatedBookcaseEvent() with Error on updated work',
      build: () => bookcaseInsertionBloc,
      setUp: () => when(
        () => bookcaseService.updateBookcase(
          bookcaseModel: bookcaseModel.copyWith(id: 1),
        ),
      ).thenAnswer((_) async => 0),
      act: (bloc) => bloc.add(UpdatedBookcaseEvent(
        id: 1,
        name: 'name',
        description: 'description',
        color: Colors.pink,
      )),
      verify: (_) {
        verify(() => bookcaseService.updateBookcase(
            bookcaseModel: bookcaseModel.copyWith(id: 1))).called(1);
      },
      expect: () => [
        isA<BookcaseInsertionLoadingState>(),
        isA<BookcaseInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test UpdatedBookcaseEvent() with LocalDatabaseException work',
      build: () => bookcaseInsertionBloc,
      setUp: () => when(
        () => bookcaseService.updateBookcase(
          bookcaseModel: bookcaseModel.copyWith(id: 1),
        ),
      ).thenThrow(LocalDatabaseException('Error on database')),
      act: (bloc) => bloc.add(UpdatedBookcaseEvent(
        id: 1,
        name: 'name',
        description: 'description',
        color: Colors.pink,
      )),
      verify: (_) {
        verify(() => bookcaseService.updateBookcase(
            bookcaseModel: bookcaseModel.copyWith(id: 1))).called(1);
      },
      expect: () => [
        isA<BookcaseInsertionLoadingState>(),
        isA<BookcaseInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test UpdatedBookcaseEvent() with Generic Exception work',
      build: () => bookcaseInsertionBloc,
      setUp: () => when(
        () => bookcaseService.updateBookcase(
          bookcaseModel: bookcaseModel.copyWith(id: 1),
        ),
      ).thenThrow(Exception('Generic Exception')),
      act: (bloc) => bloc.add(UpdatedBookcaseEvent(
        id: 1,
        name: 'name',
        description: 'description',
        color: Colors.pink,
      )),
      verify: (_) {
        verify(() => bookcaseService.updateBookcase(
            bookcaseModel: bookcaseModel.copyWith(id: 1))).called(1);
      },
      expect: () => [
        isA<BookcaseInsertionLoadingState>(),
        isA<BookcaseInsertionErrorState>(),
      ],
    );
  });
}
