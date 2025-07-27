import 'package:venure/features/notification/domain/entity/notification_entity.dart';

class NotificationModel {
  final String id;
  final String type;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'Notification',
      message: json['message'] ?? '',
      isRead: json['read'] ?? false,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      type: type,
      message: message,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
