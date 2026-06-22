import 'package:bookify/src/domain/models/custom_notification_model.dart';
import 'package:localization/localization.dart';

extension NotificationChannelExtension on NotificationChannel {
  String description() {
    return switch (this) {
      NotificationChannel.loanChannel =>
        'notification-channel-loan-description'.i18n(),
      NotificationChannel.readChannel =>
        'notification-channel-read-description'.i18n(),
    };
  }

  String get label {
    return switch (this) {
      NotificationChannel.loanChannel =>
        'notification-channel-loan-label'.i18n(),
      NotificationChannel.readChannel =>
        'notification-channel-read-label'.i18n(),
    };
  }
}
