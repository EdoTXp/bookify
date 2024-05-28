import 'dart:convert';

enum RepeatHourTimeType {
  dayly,
  weekly;

  static RepeatHourTimeType toType(int value) {
    return switch (value) {
      1 => RepeatHourTimeType.dayly,
      2 => RepeatHourTimeType.weekly,
      _ => throw Exception('Error type'),
    };
  }

  int toIntValue() {
    return switch (this) {
      RepeatHourTimeType.dayly => 1,
      RepeatHourTimeType.weekly => 2,
    };
  }
}

class UserHourTimeModel {
  final RepeatHourTimeType repeatHourTimeType;
  final int startingHour;
  final int startingMinute;
  final int endingHour;
  final int endingMinute;

  const UserHourTimeModel({
    required this.repeatHourTimeType,
    required this.startingHour,
    required this.startingMinute,
    required this.endingHour,
    required this.endingMinute,
  });

  int get timeDifferenceInSeconds => _timeDifference();

  int _timeDifference() {
    // Calculate total minutes in starting time
    int startingTimeInMinutes = (startingHour * 60) + startingMinute;

// Calculate total minutes in ending time
    int endingTimeInMinutes = (endingHour * 60) + endingMinute;

// Calculate the difference in minutes (handling negative values)
    int differenceInMinutes = endingTimeInMinutes - startingTimeInMinutes;
    if (differenceInMinutes < 0) {
      // Add a day's worth of minutes if negative
      differenceInMinutes += 24 * 60;
    }

// Convert the difference in minutes to seconds
    int differenceInSeconds = differenceInMinutes * 60;
    return differenceInSeconds;
  }

  UserHourTimeModel copyWith({
    RepeatHourTimeType? repeatHourTimeType,
    int? startingHour,
    int? startingMinute,
    int? endingHour,
    int? endingMinute,
  }) {
    return UserHourTimeModel(
      repeatHourTimeType: repeatHourTimeType ?? this.repeatHourTimeType,
      startingHour: startingHour ?? this.startingHour,
      startingMinute: startingMinute ?? this.startingMinute,
      endingHour: endingHour ?? this.endingHour,
      endingMinute: endingMinute ?? this.endingMinute,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'repeatHourTimeType': repeatHourTimeType.toIntValue(),
      'startingHour': startingHour,
      'startingMinute': startingMinute,
      'endingHour': endingHour,
      'endingMinute': endingMinute,
    };
  }

  factory UserHourTimeModel.fromMap(Map<String, dynamic> map) {
    return UserHourTimeModel(
      repeatHourTimeType:
          RepeatHourTimeType.toType(map['repeatHourTimeType'] as int),
      startingHour: map['startingHour'] as int,
      startingMinute: map['startingMinute'] as int,
      endingHour: map['endingHour'] as int,
      endingMinute: map['endingMinute'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserHourTimeModel.fromJson(String source) =>
      UserHourTimeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserHourTimeModel(repeatHourTimeType: $repeatHourTimeType, startingHour: $startingHour, startingMinute: $startingMinute, endingHour: $endingHour, endingMinute: $endingMinute)';
  }

  @override
  bool operator ==(covariant UserHourTimeModel other) {
    if (identical(this, other)) return true;

    return other.repeatHourTimeType == repeatHourTimeType &&
        other.startingHour == startingHour &&
        other.startingMinute == startingMinute &&
        other.endingHour == endingHour &&
        other.endingMinute == endingMinute;
  }

  @override
  int get hashCode {
    return repeatHourTimeType.hashCode ^
        startingHour.hashCode ^
        startingMinute.hashCode ^
        endingHour.hashCode ^
        endingMinute.hashCode;
  }
}
