import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart';
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/reading_model.dart';
import 'package:bookify/src/shared/repositories/reading_repository/reading_repository.dart';

class ReadingRepositoryImpl implements ReadingRepository {
  final LocalDatabase _database;
  final _readingTableName = DatabaseScripts().bookReadingTableName;
  final _bookTableName = DatabaseScripts().bookTableName;

  ReadingRepositoryImpl(
    this._database,
  );

  @override
  Future<List<ReadingModel>> getAll() async {
    try {
      final readingMap = await _database.getAll(
        table: _readingTableName,
        orderColumn: 'lastReadingDate',
        orderBy: OrderByType.descendant,
      );

      final readings = readingMap.map(ReadingModel.fromMap).toList();

      return readings;
    } on TypeError {
      throw const LocalDatabaseException(
        'Impossível encontrar as leituras no database',
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<ReadingModel>> getReadingsByBookTitle({
    required String title,
  }) async {
    try {
      final readingMap = await _database.getByJoin(
        columns: ['$_readingTableName.*'],
        table: _readingTableName,
        innerJoinTable: _bookTableName,
        onColumn: '$_readingTableName.bookId',
        onArgs: '$_bookTableName.id',
        whereColumn: 'title',
        whereArgs: title,
        usingLikeCondition: true,
      );

      final readings = readingMap.map(ReadingModel.fromMap).toList();

      return readings;
    } on TypeError {
      throw const LocalDatabaseException(
        'Impossível encontrar as leituras no database',
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<ReadingModel> getById({required int readingId}) async {
    try {
      final readingMap = await _database.getItemById(
        table: _readingTableName,
        idColumn: 'id',
        id: readingId,
      );

      final reading = ReadingModel.fromMap(readingMap);

      return reading;
    } on TypeError {
      throw const LocalDatabaseException(
        'Impossível encontrar a leitura no database',
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> countReadings() async {
    try {
      final countReadings = await _database.countItems(
        table: _readingTableName,
      );

      return countReadings;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required ReadingModel readingModel}) async {
    try {
      final readingId = await _database.insert(
        table: _readingTableName,
        values: readingModel.toMap(),
      );

      return readingId;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> update({required ReadingModel readingModel}) async {
    try {
      final rowUpdated = await _database.update(
        table: _readingTableName,
        values: readingModel.toMap(),
        idColumn: 'id',
        id: readingModel.id,
      );

      return rowUpdated;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> delete({required int readingId}) async {
    try {
      final deletedRow = await _database.delete(
        table: _readingTableName,
        idColumn: 'id',
        id: readingId,
      );

      return deletedRow;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
