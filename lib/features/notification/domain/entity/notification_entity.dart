class NotificationEntity {
  final String id;
  final String type;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });
}
