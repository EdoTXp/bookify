class UserPageReadingTimeModel {
  final int? pageReadingTimeSeconds;

  const UserPageReadingTimeModel({
    this.pageReadingTimeSeconds,
  });

  UserPageReadingTimeModel copyWith({
    int? pageReadingTime,
  }) {
    return UserPageReadingTimeModel(
      pageReadingTimeSeconds: pageReadingTime ?? pageReadingTimeSeconds,
    );
  }

  int readingTimeForTotalBookPage(int bookTotalPages) {
    if (pageReadingTimeSeconds != null) {
      const hourInSeconds = 3600;

      final totalReadingTimeInSeconds =
          pageReadingTimeSeconds! * bookTotalPages.toDouble();
      final totalReadingTimeInHour = totalReadingTimeInSeconds / hourInSeconds;

      return totalReadingTimeInHour.round();
    }

    return 0;
  }

  @override
  String toString() =>
      'UserPageReadingTime(pageReadingTime: $pageReadingTimeSeconds)';

  @override
  bool operator ==(covariant UserPageReadingTimeModel other) {
    if (identical(this, other)) return true;

    return other.pageReadingTimeSeconds == pageReadingTimeSeconds;
  }

  @override
  int get hashCode => pageReadingTimeSeconds.hashCode;
}
