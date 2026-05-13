enum RepeatHourTimeType {
  daily,
  weekly;

  static RepeatHourTimeType toType(int value) {
    return switch (value) {
      1 => RepeatHourTimeType.daily,
      2 => RepeatHourTimeType.weekly,
      _ => throw Exception('Error type'),
    };
  }

  int toIntValue() {
    return switch (this) {
      RepeatHourTimeType.daily => 1,
      RepeatHourTimeType.weekly => 2,
    };
  }
}
