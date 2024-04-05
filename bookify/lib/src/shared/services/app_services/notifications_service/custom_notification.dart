enum NotificationChannel {
  loanChannel,
  readChannel;

  String channelId() {
    return switch (this) {
      NotificationChannel.loanChannel => 'LoanId',
      NotificationChannel.readChannel => 'ReadId',
    };
  }

  static NotificationChannel toType(String? channelId) {
    return switch (channelId) {
      '2' => NotificationChannel.readChannel,
      '1' || _ => NotificationChannel.loanChannel,
    };
  }

  String description() {
    return switch (this) {
      NotificationChannel.loanChannel =>
        'Canal que notifica quando é o dia de receber o livro emprestado.',
      NotificationChannel.readChannel =>
        'Canal que notifica que está na hora da leitura.',
    };
  }

  @override
  String toString() {
    return switch (this) {
      NotificationChannel.loanChannel => 'Empréstimos',
      NotificationChannel.readChannel => 'Leituras',
    };
  }
}

class CustomNotification {
  final int id;
  final NotificationChannel notificationChannel;
  final String title;
  final String body;
  final DateTime scheduledDate;
  final String? payload;

  CustomNotification({
    required this.id,
    required this.notificationChannel,
    required this.title,
    required this.body,
    required this.scheduledDate,
    this.payload,
  });

  CustomNotification copyWith({
    int? id,
    NotificationChannel? notificationChannel,
    String? title,
    String? body,
    DateTime? scheduledDate,
    String? payload,
  }) {
    return CustomNotification(
      id: id ?? this.id,
      notificationChannel: notificationChannel ?? this.notificationChannel,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      payload: payload ?? this.payload,
    );
  }

  @override
  String toString() {
    return 'CustomNotification(id: $id, notificationChannel: $notificationChannel, title: $title, body: $body, scheduledDate: $scheduledDate, payload: $payload)';
  }

  @override
  bool operator ==(covariant CustomNotification other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.notificationChannel == notificationChannel &&
        other.title == title &&
        other.body == body &&
        other.scheduledDate == scheduledDate &&
        other.payload == payload;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        notificationChannel.hashCode ^
        title.hashCode ^
        body.hashCode ^
        scheduledDate.hashCode ^
        payload.hashCode;
  }
}
