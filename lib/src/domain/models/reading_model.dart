class ReadingModel {
  final int? id;
  final int pagesReaded;
  final DateTime? lastReadingDate;
  final String bookId;

  const ReadingModel({
    this.id,
    required this.pagesReaded,
    this.lastReadingDate,
    required this.bookId,
  });

  ReadingModel copyWith({
    int? id,
    int? pagesReaded,
    DateTime? lastReadingDate,
    String? bookId,
  }) {
    return ReadingModel(
      id: id ?? this.id,
      pagesReaded: pagesReaded ?? this.pagesReaded,
      lastReadingDate: lastReadingDate ?? this.lastReadingDate,
      bookId: bookId ?? this.bookId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pagesReaded': pagesReaded,
      'lastReadingDate': lastReadingDate?.millisecondsSinceEpoch,
      'bookId': bookId,
    };
  }

  factory ReadingModel.fromMap(Map<String, dynamic> map) {
    return ReadingModel(
      id: map['id'] != null ? map['id'] as int : null,
      pagesReaded: map['pagesReaded'] as int,
      lastReadingDate: map['lastReadingDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastReadingDate'] as int)
          : null,
      bookId: map['bookId'] as String,
    );
  }

  @override
  String toString() {
    return 'ReadingModel(id: $id, pagesReaded: $pagesReaded, lastReadingDate: $lastReadingDate, bookId: $bookId)';
  }

  @override
  bool operator ==(covariant ReadingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.pagesReaded == pagesReaded &&
        other.lastReadingDate == lastReadingDate &&
        other.bookId == bookId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pagesReaded.hashCode ^
        lastReadingDate.hashCode ^
        bookId.hashCode;
  }
}
