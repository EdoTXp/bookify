enum NotificationChannel {
  loanChannel,
  readChannel;

  static const int _readChannelId = 9999;

  String getChannelId() {
    return switch (this) {
      NotificationChannel.loanChannel => 'LoanId',
      NotificationChannel.readChannel => 'ReadId',
    };
  }

  int get fixedId {
    return switch (this) {
      NotificationChannel.readChannel => _readChannelId,
      NotificationChannel.loanChannel => throw UnsupportedError(
        'Loan channel utilizes dynamic IDs and does not have a single fixed ID.',
      ),
    };
  }

  static NotificationChannel fromId(int id) {
    return switch (id) {
      _readChannelId => NotificationChannel.readChannel,
      _ => NotificationChannel.loanChannel,
    };
  }
}

class CustomNotificationModel {
  final int id;
  final NotificationChannel notificationChannel;
  final String title;
  final String body;
  final String? payload;

  CustomNotificationModel({
    required this.id,
    required this.notificationChannel,
    required this.title,
    required this.body,
    this.payload,
  });

  CustomNotificationModel copyWith({
    int? id,
    NotificationChannel? notificationChannel,
    String? title,
    String? body,
    DateTime? scheduledDate,
    String? payload,
  }) {
    return CustomNotificationModel(
      id: id ?? this.id,
      notificationChannel: notificationChannel ?? this.notificationChannel,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
    );
  }

  @override
  String toString() {
    return 'CustomNotificationModel(id: $id, notificationChannel: $notificationChannel, title: $title, body: $body, payload: $payload)';
  }

  @override
  bool operator ==(covariant CustomNotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.notificationChannel == notificationChannel &&
        other.title == title &&
        other.body == body &&
        other.payload == payload;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        notificationChannel.hashCode ^
        title.hashCode ^
        body.hashCode ^
        payload.hashCode;
  }
}
