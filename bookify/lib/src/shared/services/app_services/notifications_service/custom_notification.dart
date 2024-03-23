class CustomNotification {
 final int id;
 final String title;
 final String body;
 final String channelId;
 final String channelName;
 final DateTime scheduledDate;
 final String? payload;

 CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.channelId,
    required this.channelName,
    required this.scheduledDate,
    this.payload,
 });
}